extends Control

@onready var resolution_button: OptionButton = $SettingsContainer/ResolutionContainer/ResolutionSelection
@onready var windowmode_button: OptionButton = $SettingsContainer/WindowModeContainer/WindowModeSelection

func _on_resolution_item_selected(_index):
	_update_window_size()
	

func _on_window_mode_selection_item_selected(_index):
	match windowmode_button.text.to_upper():
		"WINDOWED":
			_set_window_mode(Window.MODE_WINDOWED)
			_enable_resolution_selection()
			_update_window_size()
		"BORDERLESS FULLSCREEN":
			_set_window_mode(Window.MODE_FULLSCREEN)
			_disable_resolution_selection()
		"EXCLUSIVE FULLSCREEN":
			_set_window_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
			_disable_resolution_selection()
	

func _disable_resolution_selection():
	resolution_button.disabled = true
	
func _enable_resolution_selection():
	resolution_button.disabled = false
	
func _update_window_size():
	var values := resolution_button.text.split_floats("x")
	DisplayServer.window_set_size(Vector2i(int(values[0]), int(values[1])))
	
func _set_window_mode(window_mode):
	DisplayServer.window_set_mode(window_mode)
