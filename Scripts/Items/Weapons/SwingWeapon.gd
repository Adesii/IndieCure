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
	for i in range(swings):
		overlapping_areas = {}
		#ternary operator to determine direction of swing (even or odd) (1 or -1)
		swing_sprite.visible = true
		swing_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		rotation = Global.attack_direction.angle()

		OnAttack()
		
		var dir = 1 if i % 2 == 0 else - 1
		swing_sprite.flip_v = dir != 1
		swing_sprite.rotation = deg_to_rad( - 50 * dir)

		attack_tween = create_tween()
		attack_tween.tween_property(swing_sprite, "rotation", deg_to_rad(50 * dir), Stat.Get(self, "swing_speed"))
		attack_tween.set_ease(Tween.EASE_IN_OUT)
		attack_tween.play()

		await attack_tween.finished

		swing_sprite.visible = false
		swing_hitbox.process_mode = Node.PROCESS_MODE_DISABLED

		await get_tree().create_timer(Stat.Get(self, "attack_speed") / 2, false).timeout

	swing_sprite.visible = false
	swing_sprite.rotation = deg_to_rad( - 50)
	swing_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	attacking = false
	await get_tree().create_timer(Stat.Get(self, "attack_speed") * 2, false).timeout
	_on_attack()

func OnAttack():
	pass

func _ready():
	_on_attack()
#region Damage Calculations
var overlapping_areas: Dictionary = {}
func _physics_process(_delta):
	#only attack each area_shape once for each attack
	for area in overlapping_areas.keys():
		for shape in overlapping_areas[area]:
			Stat.Damage(self, area.get_parent(), {"shape_id": shape})
			overlapping_areas[area].erase(shape)

func _on_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int):
	if !overlapping_areas.has(area):
		return
	if overlapping_areas[area] != null:
		overlapping_areas[area].erase(area_shape_index)
	if overlapping_areas[area].size() == 0:
		overlapping_areas.erase(area)

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int):
	if not overlapping_areas.has(area):
		overlapping_areas[area] = []
	overlapping_areas[area].append(area_shape_index)

#endregion