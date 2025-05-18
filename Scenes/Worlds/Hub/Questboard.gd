extends Node2D

@export var accept_action: GUIDEAction
@export var popup_label: RichTextLabel

var inside_zone = false
func _on_area_2d_body_exited(body: Node2D) -> void:
	inside_zone = false
	popup_label.get_parent().hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	inside_zone = true
	popup_label._update_instructions()
	popup_label.get_parent().show()


func _process(delta):
	if accept_action.value_bool:
		use()

func use():
	if inside_zone:
		Global.open_pause_panel(load("uid://bhi7skm4s7wyt").instantiate())
