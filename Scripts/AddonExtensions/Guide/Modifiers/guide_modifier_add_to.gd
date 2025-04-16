## Converts the value of the input into window-absolute units between 0 and window size.
## E.g. if a mouse cursor moves half a screen to the right and down (0.5,0.5), then 
## this modifier will return (960,540) on a 1080p screen.
@tool
class_name GUIDEModifierAddTo
extends GUIDEModifier

@export var value: Vector3 = Vector3.ZERO


func _modify_input(input: Vector3, delta: float, value_type: GUIDEAction.GUIDEActionValueType) -> Vector3:
	return input + value


func _editor_name() -> String:
	return "Add To"


func _editor_description() -> String:
	return "Adds a Value to the input"
