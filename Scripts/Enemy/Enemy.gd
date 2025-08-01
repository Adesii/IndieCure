class_name Enemy
extends AnimatedMassObject

var velocity: Vector2
var avoidancevelocity: Vector2
var variable_speed: float = 1.0
var positionkey: Vector2i

var layer: String = "front"

var speed: Attribute = Attribute.new(200, self.get_instance_id(), "speed")
var health: Attribute = Attribute.new(5, self.get_instance_id(), "health")

var invulnerability: float = 0.0

var damage_frames: float = 0.0


func on_damaged(attr: Attribute, info, change_value):
	#calculate the difference between current and change value (change value can be negative)
	var damage_dealt = attr.current_value - change_value
	if change_value == attr.current_value:
		return
	# if enemy took damage display damage numbers
	if attr.current_value - change_value < 0:
		return
	DamageNumbers.add_damage_number(global_position, max(1, damage_dealt), Color(1, 1, 1, 1), 0.8)
	if damage_frames <= 0:
		damage_frames = 10

func _init() -> void:
	health.value_changing.connect(on_damaged)
