## Converts the value of the input into window-absolute units between 0 and window size.
## E.g. if a mouse cursor moves half a screen to the right and down (0.5,0.5), then 
## this modifier will return (960,540) on a 1080p screen.
@tool
class_name GUIDEModifierWindowAbsolute
extends GUIDEModifier


func _modify_input(input: Vector3, delta: float, value_type: GUIDEAction.GUIDEActionValueType) -> Vector3:
	if not input.is_finite():
		return Vector3.INF
		
	var window = Engine.get_main_loop().get_root()
	# We want real pixels, so we need to factor in any scaling that the window does.
	var window_size: Vector2 = window.get_screen_transform().affine_inverse() * Vector2(window.size)
	return Vector3(input.x * window_size.x, input.y * window_size.y, input.z)


func _editor_name() -> String:
	return "Window Absolute"


func _editor_description() -> String:
	return "Converts the value of the input into window-absolute units between 0 and window size.\n" + \
			"E.g. if a mouse cursor moves half a screen to the right and down (0.5,0.5), then \n" + \
			"this modifier will return (960,540) on a 1080p screen."
