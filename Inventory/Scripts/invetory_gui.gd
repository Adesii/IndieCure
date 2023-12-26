extends Control

@onready var inventory: Inventory = preload("res://Inventory/inventory.tres")

var slot_prefab: PackedScene = preload("res://Inventory/Scenes/inventory_slot.tscn")

@export var item_slots: Node
@onready var islots: Array = []

@export var ability_slots: Node
@onready var aslots: Array = []





func _ready():
	for i in range(inventory.max_slots):
		var slot = slot_prefab.instantiate()
		slot.set_name("ItemSlot" + str(i))
		item_slots.add_child(slot)
		islots.append(slot)
	
	for i in range(inventory.max_slots):
		var slot = slot_prefab.instantiate()
		slot.set_name("AbilitySlot" + str(i))
		ability_slots.add_child(slot)
		aslots.append(slot)


	inventory.updated.connect(update)
	update()
	

func update():
	# Updates inventory slots based on items in inventory
	for i in range(inventory.max_slots):
		islots[i].update(inventory.get_item(InventoryItem.ITEM_TYPE.WEAPON,i))
		aslots[i].update(inventory.get_item(InventoryItem.ITEM_TYPE.ABILITY,i))
