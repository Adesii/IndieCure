extends Node

func enemy_hit(area, enemy, index):
    get_parent().enemy_hit(area, enemy, index)
