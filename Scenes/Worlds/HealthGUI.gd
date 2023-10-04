extends Control

@onready var health_bar = $Health

func _ready():
	var healthAttribute = Stat.Get_Attribute(Global.player, "health")
	healthAttribute.value_changed.connect(_on_health_changed)

func _on_health_changed(attr,owner):
	var curvalclamped = clamp(attr.current_value, 0, attr.max_value)
	health_bar.scale.x = curvalclamped / attr.max_value
