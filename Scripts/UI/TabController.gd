extends Control

class_name TabController

@export var current_panel : Control

func _ready():
	# disable all children except the current panel
	for child in get_children():
		if child != current_panel:
			child.hide()

func set_current_tab(panel: Control):
	var tween = get_tree().create_tween()
	tween.tween_property(current_panel,"modulate",Color(1,1,1,0),0.2)
	tween.tween_callback(func(): 
			current_panel.hide()
			current_panel = panel
			current_panel.show()
			current_panel.modulate.a = 0
	)
	tween.tween_property(panel,"modulate",Color(1,1,1,1),0.2)
