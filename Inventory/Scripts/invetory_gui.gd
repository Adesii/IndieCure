extends Control

@onready var inventory: Inventory = preload("res://Inventory/inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	inventory.updated.connect(update)
	update()
	

func update():
	# Updates inventory slots based on items in inventory
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])
