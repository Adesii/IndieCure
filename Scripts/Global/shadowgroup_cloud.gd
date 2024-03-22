@tool
extends ColorRect
@export var offset = 0.0
@export var speed = 1.0
var time = 0.0
func _process(delta: float) -> void:
	time += delta
	material.set_shader_parameter("Time_Offset", time * 3 * speed)
	if Engine.is_editor_hint():
		return
	global_position = Global.player.global_position - (size / 2)
