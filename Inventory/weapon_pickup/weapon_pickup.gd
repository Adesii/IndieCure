extends Area2D


@export var to_open_ui_panel : PackedScene


func collect(inventory: Inventory):
	print("collect")
	if inventory.is_full(InventoryItem.ITEM_TYPE.WEAPON):
		print("inventory is full")
		return
	
	var panel = to_open_ui_panel.instantiate()
	Global.open_pause_panel(panel)
	panel.connect("close", on_panel_closed)

func on_panel_closed(panel):
	print("on_panel_closed")
	queue_free()
