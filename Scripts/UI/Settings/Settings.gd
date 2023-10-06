extends Node2D

const SETTINGS_FILE = "user://config.cfg"
var _config_file = ConfigFile.new()

var _settings = {
	"game_settings": {
		"windowMode": 0,
		"windowWidth": 1280,
		"windowHeight": 720,
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
	setGameSettings()


func loadSettings():
	print("Loading settings... at: " + SETTINGS_FILE )
	var err = _config_file.load(SETTINGS_FILE)
	if err != OK:
		print("Error loading settings: %s" % err)
		saveSettings()
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