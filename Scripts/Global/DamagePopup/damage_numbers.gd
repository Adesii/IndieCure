extends Node2D

# this script allows adding damage numbers above the heads of characters
# it also allows adding floating text above the heads of characters

# to use this script, you need to use the following script calls:
# $game_map.add_damage_number(x, y, value, color, duration)

var damage_number_scene = preload("res://Scripts/Global/DamagePopup/damage_number.tscn")

var damage_numbers_pool: Array = []

var max_amount = 100
var latest_id = 0

func add_damage_number(dmg_position, value, color, duration = 1.2):
	var damage_number = create_damage_number()

	damage_number.show()
	damage_number.global_position = dmg_position
	damage_number.set_value(value)
	damage_number.set_color(color)
	damage_number.set_duration(duration)
	damage_number.set_process(true)
	damage_number.start()


func create_damage_number() -> Node2D:
	if damage_numbers_pool.size() < max_amount:
		var new_damage_number = damage_number_scene.instantiate()
		damage_numbers_pool.append(new_damage_number)
		add_child(new_damage_number)
		return new_damage_number
	else:
		var old_damage_number = damage_numbers_pool[latest_id]
		latest_id = (latest_id + 1) % max_amount
		if old_damage_number.tween:
			old_damage_number.tween.kill()
			old_damage_number.tween.stop()
			old_damage_number.tween = null
		if old_damage_number.movement_tween:
			old_damage_number.movement_tween.kill()
			old_damage_number.movement_tween.stop()
			old_damage_number.movement_tween = null
		return old_damage_number

func remove(damage_number: Node2D):
	damage_number.set_process(false)
	damage_number.hide()
	#remove_child(damage_number)
