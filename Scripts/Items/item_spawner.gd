extends Marker2D

@export var item_scene: PackedScene
@export var item_to_spawn: InventoryItem
func spawn_item():
    var item = item_scene.instantiate()
    item.itemResource = item_to_spawn
    add_child(item)