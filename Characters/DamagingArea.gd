extends Area2D

var overlapping_areas: Dictionary = {}

func _on_area_shape_entered(_area_rid: RID, area: Area2D, area_shape_index: int, _local_shape_index: int):
	#print("Area entered shape ", area_shape_index, " local shape ", local_shape_index)

	if not overlapping_areas.has(area):
		overlapping_areas[area] = []
	overlapping_areas[area].append(area_shape_index)

func _on_area_shape_exited(_area_rid: RID, area: Area2D, area_shape_index: int, _local_shape_index: int):
	#print("Area exited shape ", area_shape_index, " local shape ", local_shape_index)

	if overlapping_areas[area] != null:
		overlapping_areas[area].erase(area_shape_index)
	if overlapping_areas[area].size() == 0:
		overlapping_areas.erase(area)

func _physics_process(_delta):
	for area in overlapping_areas.keys():
		for shape in overlapping_areas[area]:
			Stat.Damage(get_parent(), area.get_parent(), {"shape_id": shape})