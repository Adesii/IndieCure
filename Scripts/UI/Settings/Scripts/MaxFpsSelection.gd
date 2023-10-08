extends OptionButton

const max_fps_list = [
	"1",
	"10",
	"30",
	"60",
	"120",
	"144",
	"160",
	"250",
	"600"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var max_fps = Settings.getSetting("maxFps")
	for value in max_fps_list:
		self.add_item(value)

	self.selected = max_fps_list.find("%s" % max_fps)
