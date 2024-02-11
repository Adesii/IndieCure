@tool
extends EditorPlugin

static var _timeline_editor_dock: Control


var _timeline_dock_btn : Button


func _enter_tree() -> void:
	if _timeline_editor_dock == null:
		_timeline_editor_dock = (load("res://addons/enemytimeline/TimelineEditorDock.tscn") as PackedScene).instantiate()
		_timeline_dock_btn = add_control_to_bottom_panel(_timeline_editor_dock,"Timeline Editor")
		_timeline_dock_btn.toggled.connect(_on_button_pressed)

func _on_button_pressed(toggled_on) -> void:
	_timeline_editor_dock.visible = toggled_on
	


func deep_print(node: Node, depth: int = 0) -> void:
	print("\t".repeat(depth) + node.name)
	for child in node.get_children():
		deep_print(child, depth + 1)

func _exit_tree() -> void:
	if _timeline_editor_dock != null:
		_timeline_dock_btn.toggled.disconnect(_on_button_pressed)
		remove_control_from_bottom_panel(_timeline_editor_dock)
		_timeline_editor_dock.queue_free()
		_timeline_editor_dock = null
