@tool
extends ColorRect
@export var offset = 0.0
@export var speed = 1.0
var time = 0.0

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	get_parent().remove_child(self)
	Global.shadow_canvas_group.add_child(self)
func _process(delta: float) -> void:
	time += delta
	material.set_shader_parameter("Time_Offset", time * 3 * speed)
	if Engine.is_editor_hint():
		return
	global_position = Global.player.global_position - (size / 2)
