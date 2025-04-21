class_name TimedWave
extends Wave

@export var wave_duration: float = 60.0

var timer: Timer

func _start_wave():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = wave_duration
	timer.timeout.connect(self._on_wave_timeout)
	timer.start()
	
func _on_wave_timeout():
	# This function will be called when the wave duration is reached
	end_wave()

func _process_wave(delta):
	if timer:
		print("Wave is active for %f seconds" % timer.time_left)
