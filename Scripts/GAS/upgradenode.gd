extends Node
class_name UpgradeNode

func apply():
    var childs = get_children()
    for child in childs:
        child.apply()
