extends Node2D


@export var guitar_swing : AnimatedSprite2D
@export var guitar_hitbox : Area2D

var projectile_scene = preload("res://Characters/Anny/Weapons/Guitar/Guitar_projectile.tscn")

var attack_tween : Tween

var attacking : bool = false

func OnAttack():
	if attacking:
		return
	attacking = true
	var swings = Stat.Get(self,"attack_amount") as int
	for i in range(swings):
		overlapping_areas = {}
		#ternary operator to determine direction of swing (even or odd) (1 or -1)
		guitar_swing.visible = true
		guitar_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		var attackdir = Global.attack_direction
		rotation = Global.attack_direction.angle()

		spawn_projectile(attackdir,rotation)
		
		var dir = 1 if i%2 == 0 else -1
		guitar_swing.flip_v = dir != 1
		guitar_swing.rotation = deg_to_rad(-50*dir)

		
			

		attack_tween = create_tween()
		attack_tween.tween_property(guitar_swing,"rotation",deg_to_rad(50*dir),Stat.Get(self,"swing_speed"))
		attack_tween.set_ease(Tween.EASE_IN_OUT)
		attack_tween.play()

		await attack_tween.finished


		guitar_swing.visible = false
		guitar_hitbox.process_mode = Node.PROCESS_MODE_DISABLED

		await get_tree().create_timer(Stat.Get(self,"attack_speed")/2,false).timeout

	guitar_swing.visible = false
	guitar_swing.rotation = deg_to_rad(-50)
	guitar_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	attacking = false
	await get_tree().create_timer(Stat.Get(self,"attack_speed")*2,false).timeout
	OnAttack()

func spawn_projectile(dir:Vector2,rot):
	var projctileamount = Stat.Get(self,"projectile_amount") as int
	for p in range(projctileamount):
		var projectile = projectile_scene.instantiate()
		projectile.position = guitar_hitbox.global_position + guitar_swing.offset.rotated(rot)
		projectile.position += Vector2(randf_range(-10,10),randf_range(-10,10))
		projectile.direction = dir.rotated(deg_to_rad(randf_range(-10,10)))
		var parent = get_parent()
		
		# add speed to the projectile if moving in the same direction as the parent smoothly
		var dotp = dir.dot(parent.velocity.normalized())
		if dotp > 0:
			projectile.speed += parent.velocity.length() * dotp
		projectile.parent_weapon = self
		Global.current_scene.add_child(projectile)
		await get_tree().create_timer(0.05,false).timeout
	
var overlapping_areas : Dictionary = {}


func _ready():
	OnAttack()
	#guitar_swing.play()

func _physics_process(_delta):
	#only attack each area_shape once for each attack
	for area in overlapping_areas.keys():
		for shape in overlapping_areas[area]:
			Stat.Modify(area.get_parent(),"health",Stat.Get(self,"attack_damage"),"-",{"shape_id":shape})
			overlapping_areas[area].erase(shape)


func _on_area_2d_area_shape_exited(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
	if !overlapping_areas.has(area):
		return
	if overlapping_areas[area] != null:
		overlapping_areas[area].erase(area_shape_index)
	if overlapping_areas[area].size() == 0:
		overlapping_areas.erase(area)

func _on_area_2d_area_shape_entered(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
	if not overlapping_areas.has(area):
		overlapping_areas[area] = []
	overlapping_areas[area].append(area_shape_index)
