extends Node2D
class_name SwingWeapon

@export var swing_sprite: AnimatedSprite2D
@export var swing_hitbox: Area2D

var attack_tween: Tween

var attacking: bool = false

func _on_attack():
	if attacking:
		return
	attacking = true
	var swings = Stat.Get(self, "attack_amount") as int
	already_dealt_damage.clear()
	for i in range(swings):
		already_dealt_damage.clear()
		#ternary operator to determine direction of swing (even or odd) (1 or -1)
		swing_sprite.visible = true
		swing_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		rotation = Global.attack_direction.angle()

		OnAttack()
		
		var dir = 1 if i % 2 == 0 else -1
		swing_sprite.flip_v = dir != 1
		swing_sprite.rotation = deg_to_rad(-50 * dir)

		attack_tween = create_tween()
		attack_tween.tween_property(swing_sprite, "rotation", deg_to_rad(50 * dir), Stat.Get(self, "swing_speed"))
		attack_tween.set_ease(Tween.EASE_IN_OUT)
		attack_tween.play()

		await attack_tween.finished

		swing_sprite.visible = false
		swing_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
		already_dealt_damage.clear()

		await Global.create_timer(Stat.Get(self, "attack_speed") / 2).timeout
		

	swing_sprite.visible = false
	swing_sprite.rotation = deg_to_rad(-50)
	swing_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	attacking = false
	await Global.create_timer(Stat.Get(self, "attack_speed") * 2).timeout
	_on_attack()

func OnAttack():
	pass

func _ready():
	_on_attack()
#region Damage Calculations
var overlapping_areas: Dictionary = {}
var already_dealt_damage: Dictionary = {}
func _physics_process(_delta):
	#only attack each area_shape once for each attack
	for area in overlapping_areas.keys():
		for shape in overlapping_areas[area]:
			if not already_dealt_damage.has(shape):
				Stat.Damage(self, area, {"enemy": shape})
				if not already_dealt_damage.has(area):
					already_dealt_damage.set(area, [])
				if not already_dealt_damage[area].has(shape):
					already_dealt_damage[area].append(shape)
	overlapping_areas.clear()


func enemy_hit(area, enemy, area_shape_index: int):
	if not overlapping_areas.has(area):
		overlapping_areas[area] = []
	overlapping_areas[area].append(enemy)

#endregion
