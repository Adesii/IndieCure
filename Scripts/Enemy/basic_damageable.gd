extends Area2D

@export var collision_shape: Shape2D
@export var node_to_destroy: Node

@export var health_attribute: AttributePair
func _ready():
	set_physics_process(false)
	await get_tree().process_frame
	var attr: Attribute = Stat.Set(get_parent(), health_attribute.attribute_name, health_attribute.default_value)
	attr.value_changed.connect(on_health_changed)
	if collision_shape == null:
		collision_shape = get_child(0).shape
	set_physics_process(true)

var damage_frames = 0

func on_health_changed(attr, info):
	damage_frames = 10
	if attr.current_value <= 0:
		node_to_destroy.queue_free()
		queue_free()


func _physics_process(delta: float) -> void:
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape_rid = collision_shape
	query.transform = transform
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = collision_mask
	var result = space.intersect_shape(query, 1)
	if result:
		for r in result:
			if r.collider is Area2D:
				var par = r.collider.get_parent()
				if par.has_method("enemy_hit"):
					par.enemy_hit(self, null, 0)
				else:
					push_warning("Warning: No method 'enemy_hit' found on collider parent. ", r.collider.get_parent(), " is not a valid weapon or has the wrong area designated to it")
		
	
	if damage_frames > 0:
		if damage_frames == 10:
			node_to_destroy.modulate = Color(1, 1, 1) * 3
		if damage_frames == 8:
			node_to_destroy.modulate = Color(1, 1, 1) * 10
		if damage_frames == 1:
			node_to_destroy.modulate = Color(1, 1, 1)
		damage_frames -= 1
