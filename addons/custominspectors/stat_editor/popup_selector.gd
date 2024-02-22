@tool
extends Button


@export var delete: bool = false

@onready var text_edit: LineEdit = get_parent().get_node("LineEdit")


var popup: PopupMenu
func _on_Popup_index_pressed(index):
	if delete:
		print("deleted " + popup.get_item_text(index))
		StatEditorSave.remove_stat(popup.get_item_text(index))
		return
	text_edit.text = popup.get_item_text(index)
	popup.hide()

func _on_pressed() -> void:
	print("popup created")
	# create a popup dialog with 10 random items and then the selected item becomes the text of the LineEdit
	popup = PopupMenu.new()
	popup.max_size.y = 400
	popup.allow_search = true
	get_tree().get_root().add_child(popup)
	for stat in StatEditorSave.stat_list:
		popup.add_item(stat)
	popup.popup(Rect2(get_global_mouse_position(),Vector2(popup.size.x,popup.size.y)))
	popup.id_pressed.connect(_on_Popup_index_pressed)
