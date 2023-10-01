extends Node


# allows enemies to avoid eachother without having to check every enemy by splitting the map into a grid

var map_cell_size = 32;
var map_size_per_cell = 8;

var map_enemy_dict :Dictionary = {}

func get_unique_key_for_position(position: Vector2) -> int:
	#create unique index for position
	return int(position.x / map_cell_size) + int(position.y / map_cell_size) * map_size_per_cell

func get_collision_handle_request(character,positionkey):
	return {
		"character": character,
		"last_position_key": positionkey
	}

func get_surrounding_cells(last_position_key):
	var result = []
	var x = last_position_key % map_size_per_cell
	var y = int(last_position_key / map_size_per_cell)
	if x > 0:
		result.append(last_position_key - 1)
	if x < map_size_per_cell - 1:
		result.append(last_position_key + 1)
	if y > 0:
		result.append(last_position_key - map_size_per_cell)
	if y < map_size_per_cell - 1:
		result.append(last_position_key + map_size_per_cell)
	if x > 0 and y > 0:
		result.append(last_position_key - map_size_per_cell - 1)
	if x < map_size_per_cell - 1 and y > 0:
		result.append(last_position_key - map_size_per_cell + 1)
	if x > 0 and y < map_size_per_cell - 1:
		result.append(last_position_key + map_size_per_cell - 1)
	if x < map_size_per_cell - 1 and y < map_size_per_cell - 1:
		result.append(last_position_key + map_size_per_cell + 1)
	return result


func avoid_others(character,lastpositionkey,radius,with_surrounding = false):
	var result = Vector2(0,0)

	if map_enemy_dict.has(lastpositionkey):
		var enemies = map_enemy_dict[lastpositionkey]
		for enemy in enemies:
			if enemy != character:
				var distance = character.position.distance_to(enemy.position)
				if distance < radius:
					var direction = (character.position - enemy.position).normalized()
					var falloff = 1 - distance / radius
					result += direction * (radius - distance) * falloff
	# do surrounding cells
	if with_surrounding:
		var surrounding_cells = get_surrounding_cells(lastpositionkey)
		for cell in surrounding_cells:
			if map_enemy_dict.has(cell):
				var enemies = map_enemy_dict[cell]
				for enemy in enemies:
					if enemy != character:
						var distance = character.position.distance_to(enemy.position)
						if distance < radius:
							var direction = (character.position - enemy.position).normalized()
							#spherical falloff
							var falloff = 1 - distance / radius
							result += direction * (radius - distance) * falloff
	return result.normalized()

func handle_collisiongroup(character,lastpositionkey):

	var new_position_key = get_unique_key_for_position(character.position+character.velocity)

	if new_position_key == lastpositionkey:
		return {
			"last_position_key": lastpositionkey,
			"cellfull" : false
		}
	
	if map_enemy_dict.has(lastpositionkey):
		map_enemy_dict[lastpositionkey].erase(character)
	
	if map_enemy_dict.has(new_position_key):
		if map_enemy_dict[new_position_key].size() >= map_size_per_cell:
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
		






