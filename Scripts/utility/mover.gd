@tool
extends Node2D

var initial_pos: Vector2 = Vector2.ZERO
var target_pos: Vector2 = Vector2.ZERO

@export var move_dir: Vector2 = Vector2.LEFT
@export var move_distance: float = 10.0
@export var speed: float = 0.5

var open_state: bool = false

func _ready():
	initial_pos = global_position
	target_pos = initial_pos + move_dir.normalized() * move_distance
	if open_state:
		global_position = target_pos

func open_mover(_v = null):
	open_state = true
	update()

func close_mover(_v = null):
	open_state = false
	update()

func update():
	var sequence := get_tree().create_tween()
	if open_state:
		sequence.tween_property(self, "global_position", target_pos, speed)
	else:
		sequence.tween_property(self, "global_position", initial_pos, speed)
	sequence.play()
