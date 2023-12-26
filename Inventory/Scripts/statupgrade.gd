extends Node
class_name StatUpgrade

@export var stats: Array[StatUpgradeResource]


func apply():
    for stat in stats:
        stat.apply()