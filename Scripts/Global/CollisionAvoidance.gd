extends Node


# allows enemies to avoid eachother without having to check every enemy by splitting the map into a grid

var map_cell_size = 16;
var map_size_per_cell = 32;

var map_enemy_dict: Dictionary = {}

func get_unique_key_for_position(position: Vector2) -> Vector2i:
	#create unique index for position
	#print(abs(int(position.x * 1356351) ^ int(position.y * 772345)) % map_cell_size)
	return Vector2i(int(position.x / map_size_per_cell),
					int(position.y / map_size_per_cell))

func get_collision_handle_request(character, positionkey):
	return {
		"character": character,
		"last_position_key": positionkey
	}


func avoid_others(character, lastpositionkey, radius):
	var result = Vector2(0, 0)
	#var old = radius
	radius = radius * radius

	if map_enemy_dict.has(lastpositionkey):
		var enemies = map_enemy_dict[lastpositionkey].duplicate()
		enemies.append_array(map_enemy_dict.get(lastpositionkey + Vector2i(1, 0), []).duplicate())
		enemies.append_array(map_enemy_dict.get(lastpositionkey + Vector2i(-1, 0), []).duplicate())
		enemies.append_array(map_enemy_dict.get(lastpositionkey + Vector2i(0, 1), []).duplicate())
		enemies.append_array(map_enemy_dict.get(lastpositionkey + Vector2i(0, -1), []).duplicate())
		enemies.append_array(map_enemy_dict.get(lastpositionkey + Vector2i(1, 1), []).duplicate())
		enemies.append_array(map_enemy_dict.get(lastpositionkey + Vector2i(-1, -1), []).duplicate())
		enemies.append_array(map_enemy_dict.get(lastpositionkey + Vector2i(1, -1), []).duplicate())
		enemies.append_array(map_enemy_dict.get(lastpositionkey + Vector2i(-1, 1), []).duplicate())
		#print(enemies.size())
		#if enemies.size() > map_cell_size * 5:
		#	character.variable_speed = 0.1
		for enemy in enemies:
			if enemy and enemy != character:
				var distance = character.global_position.distance_squared_to(enemy.global_position)
				if distance < radius:
					var distMultiplier = 1 - (distance / radius)
					var direction = (character.global_position - enemy.global_position).normalized()
					#var falloff = 1 - distance / radius
					#result += direction * (radius - distance) * falloff
					result += direction * distMultiplier * 50
	return result

func handle_collisiongroup(character, lastpositionkey, radius):
	var new_position_key = get_unique_key_for_position(character.global_position + character.velocity)

	if new_position_key == lastpositionkey:
		return {
			"last_position_key": new_position_key,
			"cellfull": false
		}
	
	if map_enemy_dict.has(lastpositionkey):
			map_enemy_dict[lastpositionkey].erase(character)
	
	if map_enemy_dict.has(new_position_key):
		if map_enemy_dict[new_position_key].size() > map_size_per_cell:
			#print("Cell " + str(character.global_position) + " is full with " + str(map_enemy_dict[new_position_key].size()))
			return {
				"last_position_key": lastpositionkey,
				"cellfull": true
			}
		if !map_enemy_dict[new_position_key].has(character):
			map_enemy_dict[new_position_key].append(character)
	else:
		map_enemy_dict[new_position_key] = [character]
	
	return {
		"last_position_key": new_position_key,
		"cellfull": false
	}
		

func free_unit(character, lastpositionkey):
	if map_enemy_dict.has(lastpositionkey):
		map_enemy_dict[lastpositionkey].erase(character)
