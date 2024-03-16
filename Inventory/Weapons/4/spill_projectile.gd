extends Node2D

var parent_weapon = null
@export var shape: CollisionShape2D
@export var sprite: ColorRect

func _ready():
	var sizess = _get_stat("attack_size")
	shape.shape.radius = sizess
	sprite.size = Vector2(sizess * 2, sizess * 2)
	await get_tree().create_timer(Stat.Get(self, "attack_duration")).timeout
	queue_free()

func _get_stat(attribute_name, subobj=null):
	return Stat.Get(parent_weapon, attribute_name, subobj)