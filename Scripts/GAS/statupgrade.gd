extends Node
class_name StatUpgrade

@export var stats: Array[StatUpgradeResource]

func apply(target_node):
    for stat in stats:
        stat.apply(target_node)