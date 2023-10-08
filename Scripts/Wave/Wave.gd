class_name Wave

var _start_time: int	# Wave start time in seconds after stage start
var _spawner: Node

func _init(start_time, spawner):
	self._start_time = start_time
	self._spawner = spawner

func get_start_time():
	return self._start_time
		
func get_spawner():
	return self._spawner
