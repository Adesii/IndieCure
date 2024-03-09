@tool

extends Area2D

@export var itemResource: InventoryItem:
	set(val):
		itemResource = val
		if val != null:
			call_deferred("update_texture")

func _ready():
	update_texture()

func collect(inventory: Inventory):
	var success = inventory.insert(itemResource)
	if success == false:
		return
	else:
		queue_free()

func update_texture():
	if itemResource != null:
		$Sprite2D.texture = itemResource.texture