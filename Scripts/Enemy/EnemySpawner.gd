extends Node2D
class_name EnemySpawner

static var instance: EnemySpawner

@export var active_spawner := false
## Collision mask to use for the ray cast.
@export_flags_2d_physics var collision_mask: int

#var enemies = []
var enemyTypeStats: Array[StatHolder] = []
var enemyCanvas: PackedInt64Array = []

var enemy_objects: Array[MassObject]
var renderer: EnemyRenderer

var circle_shape

func _ready():
	instance = self
	circle_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(circle_shape, 8)
	renderer = EnemyRenderer.new(self)
	for i in threadcount:
		threads.append(Thread.new())

func _physics_process(delta):
	gothrough(delta)

var threads: Array[Thread]
var avoidthread: Thread
var threadcount = 2
var queue_for_deletion: Array = []

func spawn_enemy(enemy_type: EnemyArchetype, stat_holder: StatHolder):
	var spawndirection = Vector2.from_angle(randf() * 2 * PI).normalized() * 400
	spawndirection += Global.player.position
	return _new_spawn_enemy_with_type(spawndirection, enemy_type, stat_holder)

var th = Thread.new()
var mutex = Mutex.new()
var custom_delta = 0.0
func gothrough(delta):
	var playerpos = Global.player.global_position
	var space = get_world_2d().direct_space_state
	if not th.is_alive():
		if th.is_started():
			th.wait_to_finish()
		@warning_ignore("integer_division")
		var count = enemy_objects.size() / threadcount
		if count < 1:
			count = 1
		for del in queue_for_deletion:
			enemy_objects.erase(del)
			CollisionAvoidance.free_unit(del, del.positionkey)
			renderer.remove_enemy(del.archetype)
			Global.xp_drop_node.drop_xp(del.global_position, randi_range(10, 30))

		queue_for_deletion.clear()
		th.start(calc.bind(custom_delta, enemy_objects.size(), 0, playerpos, space))
		custom_delta = 0.0
	custom_delta += delta
	#return
	if avoidthread == null:
		avoidthread = Thread.new()
	
	if !avoidthread.is_alive():
		if avoidthread.is_started():
			avoidthread.wait_to_finish()
		avoidthread.start(avoidance_calc)
		#print("started avoidance thread")

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape_rid = circle_shape
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = collision_mask
	for enemy in enemy_objects:
		query.transform = enemy.transform
		var result = space.intersect_shape(query)
		if result:
			for r in result:
				if r.collider is Area2D:
					var par = r.collider
					if par.has_method("enemy_hit"):
						par.enemy_hit(self, enemy, 0)
					elif par.get_parent().has_method("enemy_hit"):
						par.get_parent().enemy_hit(self, enemy, 0)
					else:
						print("No method found for enemy_hit")


func avoidance_calc():
	for i in enemy_objects.size():
		if i >= enemy_objects.size():
			break
		var enemy = enemy_objects[i]
		if enemy == null:
			continue
		var collisiongroupresult = CollisionAvoidance.handle_collisiongroup(enemy, enemy.positionkey, 8)
		if collisiongroupresult.cellfull:
			enemy.avoidancevelocity = - enemy.velocity * 0.99
			continue
		enemy.positionkey = collisiongroupresult.last_position_key
		var collisionresult = CollisionAvoidance.avoid_others(enemy, enemy.positionkey, 32)
		enemy.avoidancevelocity = collisionresult

func calc(delta, count, startoffset, playerpos, space):
	renderer.reset_index()
	for i in count:
		if i + startoffset >= enemy_objects.size():
			break
		var enemy = enemy_objects[i + startoffset]
		var movement_vector = playerpos - enemy.global_position
		var offset: Vector2 = (movement_vector.normalized() * enemy.speed.get_value() * delta)

		enemy.animation_lifetime += delta
		
		enemy.invulnerability -= delta

		enemy.velocity = offset
		if enemy.lastfliptime > 0:
			enemy.lastfliptime -= delta
		else:
			enemy.flip_h = offset.x < 0
			enemy.lastfliptime = 0.5

		if enemy.health.current_value <= 0:
			queue_for_deletion.append(enemy)
			continue
		enemy.global_position += enemy.velocity + enemy.avoidancevelocity

		if enemy.animation_lifetime >= 0.2:
			enemy.image_offset_animation += 1
			enemy.animation_lifetime -= 0.2
			if enemy.image_offset_animation >= 4:
				enemy.image_offset_animation = 0

		if enemy.damage_frames > 0:
			if enemy.damage_frames == 10:
				enemy.modulate = Color(1, 1, 1) * 3
			if enemy.damage_frames == 8:
				enemy.modulate = Color(1, 1, 1) * 10
			if enemy.damage_frames == 1:
				enemy.modulate = Color(1, 1, 1)
			enemy.damage_frames -= 1
		renderer.update_enemy(enemy)

#func _draw():
#	_newRender()

#func _newRender():
#	for i in range(0, enemy_objects.size()):
#		var enemy = enemy_objects[i]
#		if enemy == null:
#			continue
#		if enemy.animation_lifetime >= 0.2:
#			enemy.image_offset_animation += 1
#			enemy.animation_lifetime -= 0.2
#			if enemy.image_offset_animation >= 4:
#				enemy.image_offset_animation = 0
#		var used_transform = Transform2D(0, enemy.global_position + Vector2(enemy.image_offset.x, 0))
#		enemy.transform = used_transform
#
#		var atlastexture = frames[enemy.image_offset_animation] as AtlasTexture
#		enemy.texture = atlastexture
#		var drawrect = atlastexture.get_region()
#		drawrect.position = Vector2(0, enemy.image_offset.y)
#		if !enemy.flip_h:
#			drawrect.size.x *= -1
#		enemy.texture_rect = drawrect
#
#		if enemy.damage_frames > 0:
#			if enemy.damage_frames == 10:
#				enemy.modulate = Color(1, 1, 1) * 3
#			if enemy.damage_frames == 8:
#				enemy.modulate = Color(1, 1, 1) * 10
#			if enemy.damage_frames == 1:
#				enemy.modulate = Color(1, 1, 1)
#			enemy.damage_frames -= 1
#
#		drawrect.size.y *= -1
#		drawrect.position.y -= drawrect.size.y + 2
#		enemy.shadow_texture_rect = drawrect


func _new_spawn_enemy_with_type(spawn_location: Vector2, enemy_type: EnemyArchetype, stat_holder: StatHolder) -> MassObject:
	var enemy = Enemy.new()
	enemy.global_position = spawn_location

	var get_speed_template = stat_holder._get_attribute("movement_speed")
	enemy.speed.base_value = get_speed_template.base_value
	enemy.speed.current_value = get_speed_template.current_value
	enemy.speed.max_value = get_speed_template.max_value

	var get_health_template = stat_holder._get_attribute("health")
	enemy.health.base_value = get_health_template.base_value
	enemy.health.current_value = get_health_template.current_value
	enemy.health.max_value = get_health_template.max_value

	#print("Spawning enemy of type %s with speed %d and health %d" % [enemy_type, enemy.speed.current_value, enemy.health.current_value])

	#enemy.image_offset_animation = randi() % enemy_type.frames.get_frame_count("default")
	enemy.animation_lifetime = randf_range(0, 1)

	enemy.archetype = enemy_type

	enemy_objects.append(enemy)
	renderer.add_enemy(enemy_type)
	return enemy

func _set_stat(attribute, value, subobj):
	if typeof(subobj) == TYPE_DICTIONARY:
		if subobj.has("enemy") and attribute.to_lower() == "health":
			var enemy = subobj["enemy"]
			if enemy == null:
				return 0
			return enemy.health.set_value(value)
		if subobj.has("enemy_type"):
			return enemyTypeStats[subobj["enemy_type"]]._set_stat(attribute, value)
	if typeof(subobj) == TYPE_INT:
		return enemyTypeStats[subobj]._set_stat(attribute, value)

func _get_stat(attribute, subobj):
	if typeof(subobj) == TYPE_DICTIONARY:
		if subobj.has("enemy") and attribute.to_lower() == "health":
			var enemy = subobj["enemy"]
			if enemy == null:
				return 0
			return enemy.health.get_value()
		if subobj.has("enemy_type"):
			return enemyTypeStats[subobj["enemy_type"]]._get_stat(attribute)
	if typeof(subobj) == TYPE_INT:
		return enemyTypeStats[subobj]._get_stat(attribute)
	return 0

func _modify_stat(attributename: String, value, modificationoperator, subobj = null):
	if typeof(subobj) == TYPE_DICTIONARY:
		if subobj.has("enemy") and attributename.to_lower() == "health":
			var enemy = subobj["enemy"]
			if enemy == null:
				return 0
			if enemy.invulnerability > 0:
				return 0
			enemy.invulnerability = 0.02
			return enemy.health.modify_value(value, modificationoperator)
		if subobj.has("enemy_type"):
			return enemyTypeStats[subobj["enemy_type"]]._modify_stat(attributename, value, modificationoperator)
	if typeof(subobj) == TYPE_INT:
		return enemyTypeStats[subobj]._modify_stat(attributename, value, modificationoperator)
	return 0
