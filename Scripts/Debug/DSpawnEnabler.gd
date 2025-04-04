extends Button

func _pressed() -> void:
    var spawner_node = Global.current_scene.get_node("%Spawner")
    spawner_node.active_spawner = !spawner_node.active_spawner