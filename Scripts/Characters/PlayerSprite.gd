extends Sprite2D

@onready var playersprite : CharacterBody2D = self.owner

@export var fliptimelimit = 400

var lastfliptime = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	#add a little delay to the flip so it doesn't flip every frame
	if playersprite.velocity.x > 0 and lastfliptime + fliptimelimit < Time.get_ticks_msec():
		self.flip_h = false
		lastfliptime = Time.get_ticks_msec()
	elif playersprite.velocity.x < 0 and lastfliptime + fliptimelimit < Time.get_ticks_msec():
		self.flip_h = true
		lastfliptime = Time.get_ticks_msec()

