extends Wave
class_name EnemyWave

# spawn rate in per second
@export var spawn_rate: float = 0.3:
	set(value):
		spawn_rate_converted = value / 1.0
		spawn_rate = value
	get():
		return spawn_rate

@export var max_enemies: int = 200
@export var enemy_types: Array[MultiRenderItem] = []

@export_category("Wave Enemy Attributes")
@export var health_attr := 5.0
@export var movement_attr := 32.0
@export var attack_attr := 5.0
@export var defense_attr := 5.0

func _ready():
	super._ready()
	statholder._set_stat("health", health_attr)
	statholder._set_stat("movement_speed", movement_attr)
	statholder._set_stat("attack_damage", attack_attr)
	statholder._set_stat("defense", defense_attr)
	
	spawn_rate_converted = spawn_rate / 1.0


func handle_default_spawn(delta):
	spawn_time += delta
	#print("Spawn time: %f" % spawn_time, "Spawn rate: %f" % spawn_rate_converted)
	if spawn_time >= spawn_rate_converted:
		spawn_enemy()
		spawn_time -= spawn_rate_converted

func spawn_enemy():
	if enemy_count < max_enemies:
		var enemy_type = enemy_types.pick_random()
		var enemy = Global.spawner.spawn_enemy(enemy_type, statholder)
		enemy.health.value_changing.connect(_on_enemy_health_changed)
		enemy_count += 1
		_on_enemy_spawned()

func _on_enemy_spawned():
	pass
func _on_enemy_died():
	pass
func _on_enemy_health_changed(attr, owner_info, new_value):
	if new_value <= 0:
		enemy_count -= 1
		_on_enemy_died()
