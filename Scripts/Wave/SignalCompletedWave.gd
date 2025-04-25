extends Wave
class_name SignalCompletedWave

@export var send_signal: StringName = ""

func _start_wave():
    State.sendmessage(send_signal)