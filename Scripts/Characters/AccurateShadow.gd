extends Node

@onready var sprite : Node2D = get_parent()

var dummysprite2d : Sprite2D
var copy_transform : RemoteTransform2D

func _ready():
	dummysprite2d = Sprite2D.new()
	dummysprite2d.scale = sprite.scale
	dummysprite2d.flip_v = true
	if sprite is Sprite2D:
		dummysprite2d.texture = sprite.texture
		dummysprite2d.frame_coords = sprite.frame_coords
		dummysprite2d.hframes = sprite.hframes
		dummysprite2d.vframes = sprite.vframes
	dummysprite2d.offset = Vector2(sprite.offset.x, -sprite.offset.y)
	dummysprite2d.position = sprite.position
	dummysprite2d.show_behind_parent = true
	
	Global.shadow_canvas_group.add_child.call_deferred(dummysprite2d)
	

func _physics_process(_delta):
	if dummysprite2d.is_inside_tree() and copy_transform == null :
		copy_transform = RemoteTransform2D.new()
		#copy_transform.update_scale = false
		#copy_transform.update_rotation = false
		copy_transform.remote_path = dummysprite2d.get_path()
		sprite.add_child(copy_transform)
	if copy_transform != null :
		copy_transform.position = sprite.position
	
	dummysprite2d.flip_h = sprite.flip_h
	if sprite is Sprite2D:
		dummysprite2d.frame = sprite.frame
	else: if sprite is AnimatedSprite2D:
		dummysprite2d.texture =sprite.sprite_frames.get_frame_texture(sprite.animation,sprite.frame)
	else:
		dummysprite2d.texture = null

