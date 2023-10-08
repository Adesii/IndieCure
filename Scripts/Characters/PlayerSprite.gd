extends Node2D

## Optional, if you want to use a different sprite for the animation
@export var animated_sprite : Node2D

@export var character_sprite : CharacterBody2D

@export var fliptimelimit = 400

var lastfliptime = 0

var damage_frames = 0

func _ready():
	#fallback if not assigned
	if animated_sprite == null:
		animated_sprite = self

	if animated_sprite.has_method("play"):
		animated_sprite.call("play")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if animated_sprite == null:
		return
	if character_sprite.velocity.length() > 1:
		animated_sprite.set("animation","run")
	else:
		animated_sprite.set("animation","idle")
	#add a little delay to the flip so it doesn't flip every frame
	if character_sprite.velocity.x > 0 and lastfliptime + fliptimelimit < Time.get_ticks_msec():
		animated_sprite.flip_h = false
		lastfliptime = Time.get_ticks_msec()
	elif character_sprite.velocity.x < 0 and lastfliptime + fliptimelimit < Time.get_ticks_msec():
		animated_sprite.flip_h = true
		lastfliptime = Time.get_ticks_msec()
		
	if Stat.Get(get_parent(), "is_damaged") == 1 and damage_frames == 0:
		Stat.Set(get_parent(), "is_damaged", 0)
		damage_frames = 20
	
	if damage_frames > 0:
		if damage_frames == 20:
			animated_sprite.modulate = Color(1, .4, .4)
		if damage_frames == 1:
			animated_sprite.modulate = Color(1, 1, 1)
		damage_frames -= 1
