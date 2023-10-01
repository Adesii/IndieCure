extends Node

@onready var sprite : Sprite2D = get_parent()

var dummysprite2d : Sprite2D

func _ready():
	dummysprite2d = Sprite2D.new()
	dummysprite2d.texture = sprite.texture
	dummysprite2d.scale = sprite.scale
	dummysprite2d.flip_v = true
	dummysprite2d.frame_coords = sprite.frame_coords
	dummysprite2d.hframes = sprite.hframes
	dummysprite2d.vframes = sprite.vframes
	dummysprite2d.offset = Vector2(sprite.offset.x, -sprite.offset.y)
	dummysprite2d.skew = 0.1
	dummysprite2d.modulate = Color(0,0,0,0.2)
	sprite.add_child.call_deferred(dummysprite2d)

func _physics_process(delta):
		
	
	dummysprite2d.frame = sprite.frame
	dummysprite2d.flip_h = sprite.flip_h

