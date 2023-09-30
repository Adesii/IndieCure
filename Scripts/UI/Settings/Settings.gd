extends Control

@onready var resoultion_button: OptionButton = $SettingsContainer/ResolutionContainer/ResolutionSelection
@onready var windowmode_button: OptionButton = $SettingsContainer/WindowModeContainer/WindowModeSelection

func _on_resolution_item_selected(index):
	_update_window_size()
	

func _on_window_mode_selection_item_selected(index):
	match windowmode_button.text.to_upper():
		"WINDOWED":
			_set_window_mode(Window.MODE_WINDOWED)
			_enable_resolution_selection()
			_update_window_size()
		"WINDOWED FULLSCREEN":
			_set_window_mode(Window.MODE_MAXIMIZED)
			_disable_resolution_selection()
		"FULLSCREEN":
			_set_window_mode(Window.MODE_FULLSCREEN)
			_disable_resolution_selection()
		"EXCLUSIVE FULLSCREEN":
			_set_window_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
			_disable_resolution_selection()
	

func _disable_resolution_selection():
	resoultion_button.disabled = true
	
func _enable_resolution_selection():
	resoultion_button.disabled = false
	
func _update_window_size():
	var values := resoultion_button.text.split_floats("x")
	get_window().reset_size()
	get_window().size = Vector2i(values[0], values[1])
	
func _set_window_mode(window_mode):
	get_window().mode = window_mode
