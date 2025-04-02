extends Button

@export var amounttospawn: int = 100

func _pressed() -> void:
	for i in amounttospawn:
		Global.current_scene.get_node("%Spawner").spawn_single_enemy()
