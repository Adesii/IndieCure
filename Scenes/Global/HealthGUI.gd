extends Control

@onready var health_bar = $Health

func _ready():
	var healthAttribute = Stat.Get_Attribute(Global.player, "health")
	healthAttribute.value_changed.connect(_on_health_changed)

func _on_health_changed(attr,_owner):
	var curvalclamped = clamp(attr.get_value_scaled(), 0, 1)
	health_bar.scale.x = curvalclamped
	#print("Health changed to: ", attr.current_value, " / ", attr.max_value)
