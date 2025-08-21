extends RefCounted

class_name MassObject

var archetype: MultiRenderItem
var has_shadow: bool = true

var texture_rect: Rect2
var shadow_texture_rect: Rect2
var transform: Transform2D: get = get_transform
var custom_data: Color
var modulate: Color = Color.WHITE

var position: Vector2

var global_position: Vector2: set = set_global_position

func set_global_position(new_pos):
    transform[2] = new_pos
    global_position = new_pos


func get_transform():
    transform[2] = global_position + position
    return transform