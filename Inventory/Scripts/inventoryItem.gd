extends Resource

class_name InventoryItem

enum ITEM_TYPE {
	NONE,
	WEAPON,
	ABILITY
}

@export var name: String = ""
@export var texture: Texture2D
@export var scene: PackedScene
@export var stats: Dictionary
@export var type: ITEM_TYPE = ITEM_TYPE.NONE


var instance: Node = null


func upgrade():
    if instance == null:
        return false
    var n = instance.get_node_or_null("UpgradeProvider")
    if n == null:
        return false
    return n.upgrade()