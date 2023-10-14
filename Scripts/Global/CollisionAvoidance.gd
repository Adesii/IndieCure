extends Node


# allows enemies to avoid eachother without having to check every enemy by splitting the map into a grid

var map_cell_size = 32;
var map_size_per_cell = 32;

var map_enemy_dict :Dictionary = {}

func get_unique_key_for_position(position: Vector2) -> int:
	#create unique index for position
	return int(position.x / map_cell_size) + int(position.y / map_cell_size) * map_size_per_cell

func get_collision_handle_request(character,positionkey):
	return {
		"character": character,
		"last_position_key": positionkey
	}


func avoid_others(character,lastpositionkey,radius):
	var result = Vector2(0,0)
	#var old = radius
	radius = radius * radius

	if map_enemy_dict.has(lastpositionkey):
		var enemies = map_enemy_dict[lastpositionkey]
		for enemy in enemies:
			if enemy != character:
				var distance = character.global_position.distance_squared_to(enemy.global_position)
				if distance < radius:
					var direction = (character.global_position - enemy.global_position).normalized()
					var falloff = 1 - distance / radius
					result += direction * (radius - distance) * falloff
	return result.normalized()

func handle_collisiongroup(character,lastpositionkey,radius):

	var new_position_key = get_unique_key_for_position(character.global_position+character.velocity*radius)

	if new_position_key == lastpositionkey:
		return {
			"last_position_key": new_position_key,
			"cellfull" : false
		}
	
	if map_enemy_dict.has(lastpositionkey):
			map_enemy_dict[lastpositionkey].erase(character)
	
	if map_enemy_dict.has(new_position_key):
		if map_enemy_dict[new_position_key].size() > map_size_per_cell:
			return {
				"last_position_key": lastpositionkey,
				"cellfull" : true
			}
		map_enemy_dict[new_position_key].append(character)
	else:
		map_enemy_dict[new_position_key] = [character]
	
	return {
		"last_position_key": new_position_key,
		"cellfull" : false
	}
		


func free_unit(character,lastpositionkey):
	if map_enemy_dict.has(lastpositionkey):
		map_enemy_dict[lastpositionkey].erase(character)





