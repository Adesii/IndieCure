extends Area2D

var overlapping_areas: Dictionary = {}

func enemy_hit(spawner, enemy, index):
	#print("Area entered shape ", area_shape_index, " local shape ", local_shape_index)
	if not overlapping_areas.has(spawner):
		overlapping_areas[spawner] = []
	overlapping_areas[spawner].append(enemy)
	if get_parent().has_method("enemy_hit"):
		get_parent().enemy_hit(spawner, enemy, index)

	#print("Area exited shape ", area_shape_index, " local shape ", local_shape_index)

	#if overlapping_areas[area] != null:
	#	overlapping_areas[area].erase(area_shape_index)
	#if overlapping_areas[area].size() == 0:
	#	overlapping_areas.erase(area)

var tick_count: int = 0
func _physics_process(_delta):
	if tick_count == int(Stat.Get(get_parent(), "tick_speed")):
		for area in overlapping_areas.keys():
			for shape in overlapping_areas[area]:
				Stat.Damage(get_parent(), area, {"enemy": shape})
		tick_count = 0
		for area in overlapping_areas.keys():
			overlapping_areas[area] = []
		return
	tick_count += 1
	overlapping_areas.clear()
