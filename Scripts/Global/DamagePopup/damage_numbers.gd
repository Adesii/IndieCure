extends Node2D

# this script allows adding damage numbers above the heads of characters
# it also allows adding floating text above the heads of characters

# to use this script, you need to use the following script calls:
# $game_map.add_damage_number(x, y, value, color, duration)
# $game_map.add_floating_text(x, y, text, color, duration)

var damage_number_scene = preload ("res://Scripts/Global/DamagePopup/damage_number.tscn")

var damage_numbers_pool: Array = []

func add_damage_number(dmg_position, value, color, duration=1.2):
	var damage_number: Node2D = create_damage_number()

	add_child(damage_number)
	print(damage_number)

	damage_number.global_position = dmg_position
	damage_number.set_value(value)
	damage_number.set_color(color)
	damage_number.set_duration(duration)
	damage_number.set_process(true)
	damage_number.start()

func create_damage_number():
	if damage_numbers_pool.size() > 0:
		return damage_numbers_pool.pop_back()
	else:
		return damage_number_scene.instantiate()

func remove(damage_number: Node2D):
	damage_numbers_pool.append(damage_number)
	damage_number.set_process(false)
	remove_child(damage_number)