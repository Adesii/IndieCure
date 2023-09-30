extends Control

@onready var resoultion_button: OptionButton = $SettingsContainer/ResolutionContainer/ResolutionSelection
@onready var windowmode_button: OptionButton = $SettingsContainer/WindowModeContainer/WindowModeSelection

func _on_resolution_item_selected(index):
	var values := resoultion_button.text.split_floats("x")
	get_window().size = Vector2i(values[0], values[1])


func _on_fullscreen_check_toggled(button_pressed):
	if (button_pressed):
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED


func _on_window_mode_selection_item_selected(index):
	pass # Replace with function body.
