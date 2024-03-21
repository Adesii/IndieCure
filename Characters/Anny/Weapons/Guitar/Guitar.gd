extends SwingWeapon

var projectile_scene = preload ("res://Characters/Anny/Weapons/Guitar/Guitar_projectile.tscn")

func OnAttack():
	var dir = Global.attack_direction
	var rot = Global.attack_direction.angle()

	var projctileamount = Stat.Get(self, "projectile_amount") as int
	for p in range(projctileamount):
		var projectile = projectile_scene.instantiate()
		projectile.position = swing_hitbox.global_position + swing_sprite.offset.rotated(rot)
		projectile.position += Vector2(randf_range( - 10, 10), randf_range( - 10, 10))
		projectile.direction = dir.rotated(deg_to_rad(randf_range( - 10, 10)))
		projectile.speed = 150
		projectile.parent_weapon = self
		Global.current_scene.add_child(projectile)
		await Global.create_timer(0.05).timeout
