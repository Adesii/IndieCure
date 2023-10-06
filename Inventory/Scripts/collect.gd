extends Area2D

@export var itemResource: InventoryItem

	

func collect(inventory: Inventory):
	var success = inventory.insert(itemResource)
	if success == false:
		return
	else:
		queue_free()
