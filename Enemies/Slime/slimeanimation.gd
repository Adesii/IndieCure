extends Node2D

@export var fps = 3
@export var spriteparent :Sprite2D

@onready var animationtime = randf()*1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# select the frame from 0-4 based on the current time and the fps
	animationtime += delta
	var frameindex = int(animationtime * fps) % 5
	# set the frame
	spriteparent.set_frame(frameindex)

