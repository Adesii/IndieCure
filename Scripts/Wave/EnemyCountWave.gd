extends EnemyWave
class_name EnemyCountWave

@export var target_enemies: int = 100

var total_enemy_spawned := 0


func _process_wave(delta):
    if total_enemy_spawned >= target_enemies and enemy_count == 0:
        end_wave()
        return
    if total_enemy_spawned < target_enemies:
        handle_default_spawn(delta)

func _on_enemy_spawned():
    total_enemy_spawned += 1
