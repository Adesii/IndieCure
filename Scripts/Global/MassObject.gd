extends RefCounted

class_name MassObject

var archetype: EnemyArchetype
var has_shadow: bool = true

var texture_rect: Rect2
var shadow_texture_rect: Rect2
var transform: Transform2D
var custom_data: Color
var modulate: Color = Color.WHITE


var global_position: Vector2: set = set_global_position, get = get_global_position

func set_global_position(new_pos):
    transform[2] = new_pos

func get_global_position():
    return transform[2]
