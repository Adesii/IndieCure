extends Node2D

class_name WavesController

signal UpdateTimerLabel(new_label)

var waves: Array[Wave]

var timer: Timer
var elapsed_time: int = 0
var current_wave_id: int = -1


func _ready():
	_setup_timer()


func _process(delta):
	_process_next_wave()
	_update_timer_label()


func _process_next_wave():
	var next_wave_id = current_wave_id + 1
	if(next_wave_id < waves.size()):
		if(elapsed_time >= waves[next_wave_id].get_start_time()):
			_spawn_wave(next_wave_id)
			current_wave_id = current_wave_id + 1


func _spawn_wave(wave_id):
	var spawner = waves[wave_id].get_spawner()
	if(spawner != null):
		add_child(spawner)


func _update_timer_label():
	var seconds = fmod(elapsed_time, 60)
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


func _add_wave(start_time, spawner_name):
	var spawner = get_node(spawner_name)
	remove_child(spawner)
	waves.append(Wave.new(start_time, spawner))
