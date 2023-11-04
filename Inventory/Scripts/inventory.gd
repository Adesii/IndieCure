extends Resource

class_name Inventory

signal updated
signal item_added(item: InventoryItem)

@export var items: Array[InventoryItem]

func insert(item: InventoryItem):
	# Loops throuh inventory to find empty slot to add item to.
	# If item is added to inventory: sends updated signal and returns true.
	# Returns false if item couldn't be added to inventory.

	for i in range(items.size() + 1):
		# Check if inventory is full
		if i == items.size():
			return false

		# Add item to empty inventory spot
		if !items[i]:
			items[i] = item
			break

	updated.emit()
	item_added.emit(item)
	return true


func is_full():
	# Returns true if inventory is full, false if not.

	for i in range(items.size() + 1):
		# Check if inventory is full
		if i == items.size():
			return true

		# Add item to empty inventory spot
		if !items[i]:
			return false

	return true