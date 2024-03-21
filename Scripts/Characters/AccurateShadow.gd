@tool
extends Node2D

@onready var sprite: Node2D = get_parent()

var dummysprite2d: Sprite2D
var copy_transform: RemoteTransform2D

@export var shadow_offset: Vector2 = Vector2(0, 0)
@export var shadow_scale_offset: Vector2 = Vector2(1, 1)

func _ready():
	if Engine.is_editor_hint():
		return
	dummysprite2d = Sprite2D.new()
	dummysprite2d.scale = sprite.scale
	dummysprite2d.flip_v = true

	if sprite is Sprite2D:
		dummysprite2d.texture = sprite.texture
		dummysprite2d.hframes = sprite.hframes
		dummysprite2d.vframes = sprite.vframes
		dummysprite2d.frame_coords = sprite.frame_coords
	dummysprite2d.offset = Vector2(sprite.offset.x, -sprite.offset.y)
	dummysprite2d.position = sprite.position + shadow_offset
	dummysprite2d.scale = sprite.scale * shadow_scale_offset
	dummysprite2d.show_behind_parent = true
	
	Global.shadow_canvas_group.add_child.call_deferred(dummysprite2d)
	
func _process(delta):
	if !Engine.is_editor_hint():
		return
	queue_redraw()

func _exit_tree():
	if Engine.is_editor_hint():
		return
	dummysprite2d.queue_free()

func _physics_process(_delta):
	if Engine.is_editor_hint():
		return
	dummysprite2d.visible = sprite.visible

	if dummysprite2d.is_inside_tree() and copy_transform == null:
		copy_transform = RemoteTransform2D.new()
		copy_transform.remote_path = dummysprite2d.get_path()
		copy_transform.position = sprite.position
		sprite.add_child(copy_transform)
	
	if copy_transform != null:
		copy_transform.position = sprite.position + shadow_offset
	
	dummysprite2d.flip_h = sprite.flip_h
	
	if sprite is Sprite2D:
		dummysprite2d.texture = sprite.texture
		dummysprite2d.frame = sprite.frame
	elif sprite is AnimatedSprite2D:
		dummysprite2d.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	else:
		dummysprite2d.texture = null

var editor_texture = null
var _sprite = null
func _draw():
	if !Engine.is_editor_hint():
		return

	#print("Drawing shadow")
	if _sprite == null:
		_sprite = get_parent()
		if _sprite is Sprite2D:
			editor_texture = _sprite.texture
		elif _sprite is AnimatedSprite2D:
			editor_texture = _sprite.sprite_frames.get_frame_texture(_sprite.animation, _sprite.frame)
		else:
			editor_texture = null
	if editor_texture == null:
		return
	var r = Rect2(0, 0, editor_texture.get_width(), editor_texture.get_height())
	#center the position
	r.position = _sprite.position + shadow_offset + _sprite.offset
	r.position -= Vector2(0, _sprite.offset.y) * 2
	r.position -= r.size / 2
	r.size = Vector2(r.size.x, -r.size.y)
	draw_texture_rect(editor_texture, r, false, Color(0, 0, 0, 0.5), false)
