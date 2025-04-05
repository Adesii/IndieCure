@tool
extends EditorPlugin

## JSON Editor plugin for Godot 4.x
##
## A visual editor for JSON files that provides both tree view and text editing capabilities.
## Supports all JSON data types and provides real-time validation.

var json_editor: Control

func _enter_tree() -> void:
	# Load scene with error handling
	var scene_path = "res://addons/json_editor/scenes/json_editor.tscn"
	if not ResourceLoader.exists(scene_path):
		push_error("JSON Editor: Failed to find scene file at " + scene_path)
		return
	
	var scene = load(scene_path)
	if not scene:
		push_error("JSON Editor: Failed to load scene file")
		return
	
	json_editor = scene.instantiate()
	if not json_editor:
		push_error("JSON Editor: Failed to instantiate scene")
		return
	
	# Add to main screen
	var main_screen = get_editor_interface().get_editor_main_screen()
	if not main_screen:
		push_error("JSON Editor: Failed to get editor main screen")
		return
	
	main_screen.add_child(json_editor)
	_make_visible(false)


func _exit_tree() -> void:
	if json_editor:
		json_editor.queue_free()

func _has_main_screen() -> bool:
	return true

func _get_plugin_name() -> String:
	return "JSON Editor"

func _get_plugin_icon() -> Texture2D:
	return load("res://addons/json_editor/icons/icon.svg") as Texture2D

func _make_visible(visible: bool) -> void:
	if json_editor:
		json_editor.visible = visible
