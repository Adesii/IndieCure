extends RichTextLabel
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var fps =Engine.get_frames_per_second()
	text = "FPS: " + str(fps)