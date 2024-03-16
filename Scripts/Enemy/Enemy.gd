class_name Enemy
extends MassObject

var velocity: Vector2
var avoidancevelocity: Vector2
var positionkey: int

var flip_h: bool
var lastfliptime: float

var animation_lifetime: float = 0.0
var animation_offset: float = 0.0
var image_offset_animation: int = 0
var layer: String = "front"
var speed: float = 0.0

var health: Attribute = Attribute.new(5, physics_rid, "health")

var invulnerability: float = 0.0

var damage_frames: float = 0.0

func on_damaged(attr: Attribute, info, change_value):
	if change_value == attr.current_value or change_value < 0:
		return
	# if enemy took damage display damage numbers
	if attr.current_value - change_value < 0:
		return
	if damage_frames <= 0:
		damage_frames = 10
	DamageNumbers.add_damage_number(global_position, attr.current_value - change_value, Color(1, 1, 1, 1), 0.8)

func _init() -> void:
	health.value_changing.connect(on_damaged)
