extends WavesController


func _ready():
	super._add_wave(0, "non-existing-spawner-1")
	super._add_wave(1, "TofSpawner")
	super._add_wave(20, "non-existing-spawner-2")

	super._ready()
