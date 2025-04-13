@tool

extends Area2D

@export var itemResource: InventoryItem:
	set(val):
		itemResource = val
		if val != null:
			call_deferred("update_texture")

var time: float = 0.0
var speed: float = 1.5
var strength: float = 2.0

var start_offset: Vector2
func _ready():
	update_texture()
	start_offset = $Sprite2D.offset
	time = randf() * 2.0 * PI

func _process(delta):
	if Engine.is_editor_hint():
		return
	time += delta * speed
	$Sprite2D.offset.y = start_offset.y + sin(time) * strength


func collect(inventory: Inventory):
	var success = inventory.insert(itemResource)
	if success == false:
		return
	else:
		queue_free()

func update_texture():
	if itemResource != null:
		$Sprite2D.texture = itemResource.texture