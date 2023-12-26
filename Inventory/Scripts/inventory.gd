extends Resource

class_name Inventory

signal updated
signal item_added(item: InventoryItem)

@export var items: Dictionary

func insert(item: InventoryItem):
	# Adds item to inventory. Returns true if successful, false if not.
	var type = item.type
	if type == InventoryItem.ITEM_TYPE.NONE:
		printerr("Inventory: Item type is NONE for item " + str(item))
		return false
	
	if !items[type]:
		items[type] = []
	
	# look through inventory to find of same type
	for i in range(items[type].size()):
		if items[type][i]:
			if item.name == items[type][i].name:
				return items[type][i].upgrade()
					
	# look for empty slot
	for i in range(items[type].size()):
		if !items[type][i]:
			items[type][i] = item
			updated.emit()
			item_added.emit(item)
			return true

	return false


func is_full(type: InventoryItem.ITEM_TYPE):
	# Returns true if inventory is full, false if not.

	if !items[type]:
		return false
	
	for i in range(items[type].size()):
		if !items[type][i]:
			return false
	return true