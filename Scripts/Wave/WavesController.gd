@tool
extends Node

class_name WavesController

signal UpdateTimerLabel(new_label)

var waves: Array[Wave]

var timer: Timer
var elapsed_time: int = 0
var current_wave_id: int = -1


func _ready():
	if Engine.is_editor_hint():
		return
	_setup_timer()
	for i in range(get_child_count()):
		var child = get_child(i)
		if child is Wave:
			waves.append(child)
			child.set_process(false)
			child.set_process_input(false)
			child.set_physics_process(false)

	waves[0].start(self)

func _process(_delta):
	_update_timer_label()


func next_wave():
	var next_wave_id = current_wave_id + 1
	if (next_wave_id < waves.size()):
			current_wave_id = current_wave_id + 1
			waves[current_wave_id].start(self)


func _update_timer_label():
	var seconds = fmod(elapsed_time, 60)
	@warning_ignore("integer_division")
	var minutes = elapsed_time / 60
	var new_label = "%02d:%02d\nWave %2d/%2d" % [minutes, seconds, current_wave_id + 1, waves.size()]
	UpdateTimerLabel.emit(new_label)
	

func _on_timer_timeout():
	elapsed_time = elapsed_time + 1


func _setup_timer():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(self._on_timer_timeout)
	timer.wait_time = 1.0
	timer.start()
