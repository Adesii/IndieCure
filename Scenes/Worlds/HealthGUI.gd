extends Control

@onready var health_bar = $Health


func _process(delta):
	if Global.player == null:
		return
	var healthAttribute = Stat.Get_Attribute(Global.player, "health")
	health_bar.scale.x = healthAttribute.current_value / healthAttribute.max_value
