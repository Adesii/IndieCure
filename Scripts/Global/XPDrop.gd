extends Node2D

class_name XPDrop

class xp_drop extends MassObject:
	var amount: float
	var radius: float = 8

	#up-down movement cycle
	var cycle_time: float = 0
	# pickup stuff
	var picked_up: bool = false
	var pickup_time: float = 0

var max_xp_per_drop = 1000

@export var shared_area: Area2D

@export var xp_texture: Texture2D

var enemy_drop_amount = 10;

var drops: Array[xp_drop]

var renderer: MultiRenderer

var circle_shape

func _ready():
	circle_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(circle_shape, 4)

	xp_texture = preload("uid://cav63ncdxq45b")
	renderer = MultiRenderer.new(self)
	pass # Replace with function body.

func _physics_process(_delta):
	renderer.reset_index()
	var offset = xp_texture.get_size() / 2
	var space = get_world_2d().direct_space_state
	for drop in drops:
		if drop == null:
			continue
		
		# move the drop up and down 
		drop.cycle_time += _delta
		offset.y = sin(drop.cycle_time * 200 * _delta) * 2

		# move the drop to the player if picked up and then remove it
		if drop.picked_up:
			drop.pickup_time += _delta
			# add a bit of upwards arc before droping back down
			var drop_movement = Vector2(0, 0)
			# direction movement:
			drop_movement += (Global.player.global_position - drop.global_position).normalized() * clamp(easeInCirc(drop.pickup_time * 30 * _delta), 0, 1) * 100
			
			var signs = 1
			if drop.pickup_time > 0.5:
				signs = -1
			# add a bit of upwards movement based on direction
			drop_movement.y -= clamp(easeOutBack(signs * drop.pickup_time * 30 * _delta), 0, 1) * 3

			if drop.pickup_time > 3.0:
				dead_xp.append(picked_xp(drop))
				#continue

			# lerp the position using the pickup time and easeInCirc function
			drop.global_position = drop_movement + drop.global_position
			if drop.global_position.distance_to(Global.player.global_position) < 5:
				dead_xp.append(picked_xp(drop))
				#continue

		#drop.archetype.framesstrip = xp_texture
		var drawrect = Rect2(0, 0, drop.archetype.framesstrip.get_width(), drop.archetype.framesstrip.get_height())
		drop.position = - offset

		drop.texture_rect = drawrect

		drawrect.size.y *= -1
		drawrect.position.y -= drawrect.size.y + 2
		drop.shadow_texture_rect = drawrect
		drop.shadow_texture_rect.position.y += offset.y * 2
		renderer.update_enemy(drop)
		if drop.picked_up:
			continue

		var query = PhysicsShapeQueryParameters2D.new()
		query.shape_rid = circle_shape
		query.transform = Transform2D(0, drop.global_position)
		query.collide_with_areas = true
		query.collide_with_bodies = false
		query.collision_mask = shared_area.collision_mask
		var result = space.intersect_shape(query, 1)
		if result:
			for r in result:
				if r.collider and r.collider is Area2D:
					drop.picked_up = true
					drop.pickup_time = randf_range(0, 0.01)

	for xp in dead_xp:
		renderer.remove_item(xp.archetype)
		drops.erase(xp)
	dead_xp.clear()
	
func picked_xp(obj):
	# TODO: add xp to global player... needs a way to get the player later on when multiplayer is a thing
	Stat.Modify(Global.player, "xp", obj.amount, "+")

	return obj

var dead_xp = []

func drop_xp(dropposition: Vector2, amount: int):
	#var space = get_world_2d().direct_space_state
	#var query = PhysicsShapeQueryParameters2D.new()
	#query.shape_rid = circle_shape
	#query.transform = Transform2D(0, dropposition)
	#query.collide_with_areas = true
	#query.collide_with_bodies = false
	#query.collision_mask = shared_area.collision_mask
	#var result = space.intersect_shape(query, 2)
	#if result:
	#	for xpd in result:
	#		if xpd.collider != shared_area:
	#			continue
	#		if renderer._objects.size() > xpd.shape:
	#			var dropxpd = renderer._objects[xpd.shape]
	#			if dropxpd.amount + amount > max_xp_per_drop:
	#				continue
	#			dropxpd.amount += amount
	#			dropxpd.global_position = (dropxpd.global_position - dropposition) / 2 + dropposition
	#			return
	#		else:
	#			print("Something went wrong, the shape is not in the renderer")
	var drop = xp_drop.new()
	drop.global_position = dropposition
	drop.amount = amount
	drop.archetype = preload("uid://cx0vsrxrerg52")
	#drop.has_shadow = true
	renderer.add_item(drop.archetype)
	drops.append(drop)

	# Add the shape to the shared area
	#PhysicsServer2D.area_add_shape(
	#	shared_area.get_rid(), circle_shape, drop.transform
	#)
	
	# Register the generated id to the bullet
	#drop.physics_rid = _circle_shape

	
func easeInCirc(x):
	return 1 - sqrt(1 - pow(x, 2));

func easeOutBack(x):
	const c1 = 1.70158;
	const c3 = c1 + 1;
	
	return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2);

func pickup(local_shape_index):
	var drop = renderer.get_object(local_shape_index)
	if drop != null:
		if drop.picked_up:
			return
		drop.picked_up = true
		drop.pickup_time = randf_range(0, 0.01)

		#PhysicsServer2D.free_rid(drop.physics_rid)

		# remove the shape from the area
		#PhysicsServer2D.area_remove_shape(shared_area.get_rid(), local_shape_index)
