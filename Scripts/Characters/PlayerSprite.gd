extends Sprite2D

@onready var playersprite : CharacterBody2D = self.owner
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if playersprite.velocity.x > 0:
		self.flip_h = false
	elif playersprite.velocity.x < 0:
		self.flip_h = true

