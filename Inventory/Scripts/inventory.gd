extends Resource

class_name Inventory

signal updated
signal item_added(item: InventoryItem)

@export var items: Dictionary

@export var max_slots: int = 6


func insert(item: InventoryItem):
	# Adds item to inventory. Returns true if successful, false if not.
	var type = item.type
	if type == InventoryItem.ITEM_TYPE.NONE:
		printerr("Inventory: Item type is NONE for item " + str(item))
		return false

	if items.has(type) == false:
		var arr : Array[InventoryItem] = []
		arr.resize(max_slots)
		items[type] = arr
	
	# look through inventory to find of same type
	for i in range(items[type].size()):
		if items[type][i] != null:
			if item.name == items[type][i].name:
				return items[type][i].upgrade()
					
	# look for empty slot
	for i in range(items[type].size()):
		if items[type][i] == null:
			items[type][i] = item
			updated.emit()
			item_added.emit(item)
			return true
		
	print("Inventory: No empty slots for item " + str(item))
	return false


func get_item(type: InventoryItem.ITEM_TYPE, index: int):
	if type == InventoryItem.ITEM_TYPE.NONE:
		return false

	if items.has(type) == false:
		var arr : Array[InventoryItem] = []
		arr.resize(max_slots)
		items[type] = arr

	# Returns item at index of type. Returns null if no item.
	if items.has(type) == false:
		printerr("Inventory: No items of type " + str(type))
		return null
	
	if index >= items[type].size():
		printerr("Inventory: Index out of range for type " + str(type) + " index " + str(index))
		return null
	return items[type][index]


func is_full(type: InventoryItem.ITEM_TYPE):
	# Returns true if inventory is full, false if not.

	if !items[type]:
		return false
	
	for i in range(items[type].size()):
		if !items[type][i]:
			return false
	return true
