extends OptionButton

var resolutions = [
	"1280x720",
	"1366x768",
	"1600x900",
	"1920x1080",
	"2560x1440",
	"3840x2160"
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	var windowWidth = Settings.getSetting("windowWidth")
	var windowHeight = Settings.getSetting("windowHeight")
	var current_resolution = resolutions.find("%sx%s" % [windowWidth, windowHeight])
	var display_resoultion = DisplayServer.screen_get_size()
	
	# Try adding only resolutions lower than actual screen resolution
	for item in resolutions:
		var splitted_res = item.split_floats("x")
		if (splitted_res[0] < display_resoultion.x && splitted_res[1] < display_resoultion.y):
			self.add_item(item)
	
	# Fallback in the case of no resolution added in previous step
	if (self.item_count == 0):
		for item in resolutions:
			self.add_item(item)
			
	# By default select highest possible resolution
	self.selected = current_resolution
