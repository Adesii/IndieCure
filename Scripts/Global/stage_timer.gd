extends Node

var time := 0.0
func _ready():
	time = 0.0

func _process(delta):
	time += delta
	var minutes = floor(time / 60.0)
	var seconds = floor(fmod(time, 60.0))
	var formatted_time = str("%02d:%02d" % [minutes, seconds])
	State.sendmessage("UpdateTimerLabel", [formatted_time])
	State.set_value("stage_timer", snappedf(time, 0.01))
