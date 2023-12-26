extends Node
class_name UpgradeProvider

@export var level = 0


func upgrade():
    var node = get_child(level)
    if node != null:
        level += 1
        node.apply()
        return true
    return false