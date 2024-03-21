extends Node2D

#if spill_list is empty start a coolddown afterwards fill it based on projectile amount and start again
var spill_List = []
var spill_projectile: PackedScene = load("res://Inventory/Weapons/4/spill_projectile.tscn")

func attack() -> void:
	if spill_List.size() != 0:
		await get_tree().physics_frame
		spill_List = spill_List.filter(func x(n): return n != null)
		attack()
		return
	await Global.create_timer(Stat.Get(self, "attack_speed")).timeout
	for i in range(Stat.Get(self, "projectile_amount")):
		var projectile = spill_projectile.instantiate()
		projectile.parent_weapon = self
		spill_List.append(projectile)
		Global.current_scene.add_child(projectile)
		#set a random position around the player in a circle range of 50-150 distance
		var angle = randf_range(0, 360)
		var distance = randf_range(50, 150)
		var x = cos(angle) * distance
		var y = sin(angle) * distance
		projectile.position = to_global(Vector2(x, y))
	
	await get_tree().physics_frame
	attack()

func _ready():
	attack()