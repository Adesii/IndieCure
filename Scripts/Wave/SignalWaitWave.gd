extends Wave
class_name SignalWaitWave

@export var await_signal: StringName = ""

func _start_wave():
	State.registernode(self, await_signal, _on_signal_received)

func _on_signal_received(args = []):
		end_wave()