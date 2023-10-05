extends Control

@onready var resolution_button: OptionButton = $SettingsContainer/ResolutionContainer/ResolutionSelection
@onready var windowmode_button: OptionButton = $SettingsContainer/WindowModeContainer/WindowModeSelection
@onready var max_fps_button: OptionButton = $SettingsContainer/MaxFpsContainer/MaxFpsSelection
@onready var vsync_enabled_button: CheckButton = $SettingsContainer/VsyncContainer/VsyncCheckButton

const SETTINGS_FILE = "res://Scripts/UI/Settings/config.cfg"
var _config_file = ConfigFile.new()

var _settings = {
	"game_settings": {
		"windowMode": 0,
		"windowWidth": 1600,
		"windowHeight": 900,
		"vsyncEnabled": 0,
		"maxFps": 120,
	}
}


func _ready():
	loadSettings()
	setGameSettings()


func saveSettings():
	for section in _settings.keys():
		for key in _settings[section].keys():
			_config_file.set_value(section, key, _settings[section][key])
	_config_file.save(SETTINGS_FILE)


func loadSettings():
	var err = _config_file.load(SETTINGS_FILE)
	if err != OK:
		print("Error loading settings: %s" % err)
		return []
	var values = []
	for section in _settings.keys():
		for key in _settings[section].keys():
			var val = _settings[section][key]
			_settings[section][key] = _config_file.get_value(section, key, val)
			print("%s %s" % [key, val])
	return values


func getSetting(key):
	return _settings["game_settings"][key]


func setSetting(key, value):
	_settings["game_settings"][key] = value
	saveSettings()


func setGameSettings():
	DisplayServer.window_set_mode(getSetting("windowMode"))
	DisplayServer.window_set_size(Vector2i(getSetting("windowWidth"), getSetting("windowHeight")))
	DisplayServer.window_set_vsync_mode(getSetting("vsyncEnabled"))
	Engine.set_max_fps(getSetting("maxFps"))


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
	setSetting("windowWidth", int(values[0]))
	setSetting("windowHeight", int(values[1]))
	DisplayServer.window_set_size(Vector2i(int(values[0]), int(values[1])))
	
func _set_window_mode(window_mode):
	setSetting("windowMode", window_mode)
	DisplayServer.window_set_mode(window_mode)

func _on_max_fps_selection_item_selected(_index):
	var value = int(max_fps_button.text)
	setSetting("maxFps", value)
	Engine.set_max_fps(value)

func _on_vsync_check_button_pressed():
	var vsync = vsync_enabled_button.button_pressed
	if vsync == true:
		vsync = 1
	else:
		vsync = 0
	setSetting("vsyncEnabled", vsync)
	DisplayServer.window_set_vsync_mode(vsync)
