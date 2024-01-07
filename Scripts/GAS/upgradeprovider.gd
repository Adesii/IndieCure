extends Node
class_name UpgradeProvider

@export var level = 0

@export var target: TARGET = TARGET.WEAPON

@export var target_node: Node

enum TARGET {
    PLAYER,
    WEAPON,
    TARGET
}


func upgrade():
    if level >= get_child_count():
        return false
    if target == TARGET.PLAYER:
        target_node = Global.player
    elif target == TARGET.WEAPON:
        target_node = get_parent()
    var node = get_child(level)
    if node != null:
        level += 1
        print("Upgrading to level: " + str(level) + " of " + str(get_child_count()) + " for " + str(target_node))
        node.apply(target_node)
        if target_node.has_method("upgraded"):
            target_node.upgraded()
        return true
    return false