extends Node2D

var parent_weapon = null
var direction = Vector2(1, 0)
var speed = 200

func _get_stat(attribute_name, subobj=null):
	return Stat.Get(parent_weapon, attribute_name, subobj)

func _ready():
	await get_tree().create_timer(4).timeout
	queue_free()

func _physics_process(delta):
	var move = direction * speed * delta
	position += move

func _on_basic_damage_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	queue_free()
