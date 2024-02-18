extends Area2D


@export var collision_shape : CollisionShape2D
@export var collision_type_shape : CircleShape2D

var attr : Attribute

var query 
var physicsspace
var _circle_shape_query

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attr = Stat.Get_Attribute(get_parent(),"pickup_radius")
	attr.value_changed.connect(on_size_changed)
	collision_type_shape.radius = attr.current_value
	collision_shape.shape = collision_type_shape

	_circle_shape_query = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(_circle_shape_query, collision_type_shape.radius)
	query = PhysicsShapeQueryParameters2D.new()
	query.shape_rid = _circle_shape_query

	



func _physics_process(delta: float) -> void:
	# do a area query to pick up xp
	
	query.transform = Transform2D(0, global_position)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = collision_mask
	query.exclude = [self]
	physicsspace = get_world_2d().direct_space_state

	var result = physicsspace.intersect_shape(query)
	if result.size() == 0:
		return
	#print(result)

	for d in result:
		var shape_index = d.shape
		var area = d["collider"]
		if area == self:
			continue

		area.get_parent().pickup(shape_index)
		

func on_size_changed() -> void:
	collision_type_shape.radius = attr.current_value
	collision_shape.shape = collision_type_shape
	PhysicsServer2D.shape_set_data(_circle_shape_query, collision_type_shape.radius)