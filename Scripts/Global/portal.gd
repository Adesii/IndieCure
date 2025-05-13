extends Node2D

var portal_destination: StringName
@export var accept_action: GUIDEAction

var inside_portal = false
func _on_area_2d_body_exited(body: Node2D) -> void:
	inside_portal = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	inside_portal = true

func _process(delta):
	if accept_action.value_bool:
		use_portal()

func use_portal():
	if inside_portal:
		Global.change_scene(portal_destination)
