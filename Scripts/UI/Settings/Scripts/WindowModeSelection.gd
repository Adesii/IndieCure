extends OptionButton

const window_modes = [
	Window.MODE_WINDOWED,
	Window.MODE_FULLSCREEN,
	Window.MODE_EXCLUSIVE_FULLSCREEN
]

func _ready():
	var window_mode = Settings.getSetting("windowMode")
	var idx = window_modes.find(window_mode)
	self.selected = idx
