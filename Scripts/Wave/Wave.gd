class_name Wave
extends StatHolderNode

var wave_controller: WavesController

var enemy_count: int = 0
var spawn_time: float = 0.0

var spawn_rate_converted: float = 0.0

func init_wave():
	set_process(true)
	set_process_input(true)
	set_physics_process(true)

func end_wave():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	wave_controller.next_wave()
	
func _ready():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	for attribute in starting_attributes:
		statholder._set_stat(attribute.attribute_name, attribute.default_value)

func start(controller: WavesController):
	wave_controller = controller
	init_wave()
	_start_wave()


func _process(delta):
	_process_wave(delta)


#region overridable functions

func _start_wave():
	# Logic to start the wave
	pass

func _process_wave(delta):
	# logic to process the wave
	pass