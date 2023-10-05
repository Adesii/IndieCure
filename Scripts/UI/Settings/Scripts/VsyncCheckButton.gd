extends CheckButton


func _ready():
	var vsync_enabled = Settings.getSetting("vsyncEnabled")
	if vsync_enabled == 0:
		self.button_pressed = false
	else:
		self.button_pressed = true
