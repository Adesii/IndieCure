extends RefCounted

class_name MassObject

var physics_rid : RID
var rendering_rid : RID
var rendering_shadow_rid : RID
var texture : Texture2D
var texture_rect : Rect2
var shadow_texture_rect : Rect2
var transform : Transform2D
var image_offset : Vector2
var modulate : Color


var global_position : Vector2 : set = set_global_position, get = get_global_position

func set_global_position(new_pos):
    transform[2] = new_pos

func get_global_position():
    return transform[2]
    

