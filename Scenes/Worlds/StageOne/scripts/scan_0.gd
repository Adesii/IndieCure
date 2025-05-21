extends Marker2D

@export var distance_to_count := 20.0

var time = 0.0

func _physics_process(delta: float) -> void:
    if Global.player.global_position.distance_to(global_position) < distance_to_count:
        time += delta
        State.set_value("loc_scan0_time", time)
        State.set_value("loc_scan0", true)
    else:
        State.set_value("loc_scan0", false)