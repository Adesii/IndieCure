extends Node2D

@export var texture: Texture2D
@export var radius: float
@export var attack_stay_time: float = 2.0
@export var attack_time: float = 0.3
@export var size: float = 16

@export var shared_area: Area2D

signal finished_attack

var overlapping_areas: Dictionary = {}

func _on_area_2d_area_shape_entered(_area_rid: RID, area: Area2D, area_shape_index: int, _local_shape_index: int):
	#print("Area entered shape ", area_shape_index, " local shape ", _local_shape_index)

	if not overlapping_areas.has(area):
		overlapping_areas[area] = []
	overlapping_areas[area].append(area_shape_index)

func _on_area_2d_area_shape_exited(_area_rid: RID, area: Area2D, area_shape_index: int, _local_shape_index: int):
	#print("Area exited shape ", area_shape_index, " local shape ", _local_shape_index)

	if overlapping_areas[area] != null:
		overlapping_areas[area].erase(area_shape_index)
	if overlapping_areas[area].size() == 0:
		overlapping_areas.erase(area)

class attackpoint:
	var offset: Vector2
	var rotation: float
	var radius: float
	var sprite_id: RID
	var shape_id: RID
	var tweener: Tween
	var used_transform: Transform2D

var attacks: Array[attackpoint]

var is_attacking: bool = false
var attack_timer: SceneTreeTimer

var alpha: float = 1.0

func _on_attack():
	var amount = Stat.Get(self, "projectile_amount")
	#print("attack")
	
	is_attacking = true
	if attacks.size() < amount:
		#create more attack points if needed
		#print("create more attack points")
		while attacks.size() < amount:
			create_new_attack_point()
	for point in attacks:
		point.tweener = get_tree().create_tween()
		point.tweener.tween_method(func(x: float):
			point.offset=Vector2(radius * x, 0)
			alpha=x
			, 0.0, 1.0, 0.3
		)
		if Stat.Get(self, "never_ending"):
			point.tweener.play()
			continue
		point.tweener.tween_interval(attack_stay_time)
		point.tweener.tween_method(func(x: float):
			point.offset=Vector2(radius * x, 0)
			alpha=x
			, 1.0, 0.0, 0.3
		)
		point.tweener.play()
	if Stat.Get(self, "never_ending"):
		return
	await attacks[0].tweener.finished
	await get_tree().create_timer(attack_time).timeout

	finished_attack.emit()
	is_attacking = false
	#print("finished attack")

func cancel_attack():
	for point in attacks:
		point.tweener.stop()
		point.offset = Vector2(0, 0)
		alpha = 1.0
	is_attacking = false

func _physics_process(delta):
	if !is_attacking:
		_on_attack()
		return
	rotation += Stat.Get(self, "projectile_speed") * delta

	for i in range(attacks.size()):
		var point = attacks[i]
		var point_rotation_offset = (i * (360.0 / attacks.size()))
		var poinoffset = point.offset.rotated(deg_to_rad(point_rotation_offset))
		var used_transform := Transform2D( - rotation, poinoffset)
		PhysicsServer2D.area_set_shape_transform(
			shared_area.get_rid(), i, used_transform
		)
		point.used_transform = used_transform

	for area in overlapping_areas.keys():
		for shape in overlapping_areas[area]:
			Stat.Damage(self, area.get_parent(), {"shape_id": shape})
	queue_redraw()

func _draw():
	var offset = texture.get_size() / 2
	var texturesize = texture.get_size()
	for i in range(attacks.size()):
		var point = attacks[i]
		RenderingServer.canvas_item_clear(point.sprite_id)
		RenderingServer.canvas_item_set_transform(point.sprite_id, point.used_transform)
		#RenderingServer.canvas_item_add_circle(point.sprite_id,Vector2(), point.radius, Color(1,1,1,1))
		texture.draw_rect(point.sprite_id, Rect2(Vector2() - offset * (size / texturesize.length() * 3), texturesize * (size / texturesize.length() * 3)), false, Color(1, 1, 1, alpha))

func create_new_attack_point():
	var new_attack_point = attackpoint.new()
	new_attack_point.offset = Vector2(0, 0)
	_configure_collision_for_attackpoint(new_attack_point)
	attacks.append(new_attack_point)

	new_attack_point.sprite_id = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(new_attack_point.sprite_id, get_canvas_item())

func _configure_collision_for_attackpoint(point: attackpoint):
	# Define the shape's position
	var used_transform := Transform2D(0, position)
	used_transform.origin = point.offset
	# Create the shape
	var _circle_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(_circle_shape, size)

	# Add the shape to the shared area
	PhysicsServer2D.area_add_shape(
		shared_area.get_rid(), _circle_shape, used_transform
	)
	
	# Register the generated id to the bullet
	point.shape_id = _circle_shape

func upgraded():
	cancel_attack()
