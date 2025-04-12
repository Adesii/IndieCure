class_name Wave
extends StatHolderNode

# spawn rate in per second
@export var spawn_rate: float = 0.3:
	set(value):
		spawn_rate_converted = value / 1.0
		spawn_rate = value
	get():
		return spawn_rate

@export var max_enemies: int = 200
@export var enemy_types: Array[EnemyArchetype] = []

var wave_controller: WavesController

var enemy_count: int = 0
var spawn_time: float = 0.0

var spawn_rate_converted: float = 0.0

func init_wave():
	set_process(true)
	set_process_input(true)
	set_physics_process(true)
	
func _ready():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	for attribute in starting_attributes:
		statholder._set_stat(attribute.attribute_name, attribute.default_value)
	
	spawn_rate_converted = spawn_rate / 1.0

func start(controller: WavesController):
	wave_controller = controller
	init_wave()
	_start_wave()

func _start_wave():
	# Logic to start the wave
	pass

func process_wave(delta):
	spawn_time += delta
	#print("Spawn time: %f" % spawn_time, "Spawn rate: %f" % spawn_rate_converted)
	if spawn_time >= spawn_rate_converted:
		spawn_enemy()
		spawn_time -= spawn_rate_converted

func spawn_enemy():
	if enemy_count < max_enemies:
		var enemy_type = enemy_types[randi() % enemy_types.size()]
		var enemy = EnemySpawner.instance.spawn_enemy(enemy_type, statholder)
		enemy.health.value_changing.connect(_on_enemy_health_changed)
		enemy_count += 1

func _on_enemy_health_changed(attr, owner_info, new_value):
	if new_value <= 0:
		enemy_count -= 1
