extends Control

@export var xp_bar : Control
@export var lvl_text : RichTextLabel

@export var to_open_ui_panel : PackedScene

var level : int = 1

var transition : Tween




func _ready():
	var xpAttribute = Stat.Get_Attribute(Global.player, "xp")
	xpAttribute.max_value = round((pow(level, 1.8) + level * 4)*10)
	xpAttribute.value_changed.connect(_on_xp_changed)
	xpAttribute.value_maxed.connect(_on_xp_maxed)
	xp_bar.scale.x = 0

func _on_xp_changed(attr,_info):
	var xpAttribute = attr
	lvl_text.text ="lvl: "+ str(level) + "\nXP: " + str(xpAttribute.current_value) + " / "+ str(xpAttribute.max_value)

	#TODO: figure out how to do this correctly so it actually wraps around instead of snapping to the new value when a level up happens
	var curvalclamped = clamp(xpAttribute.get_value_scaled(), 0, 1)
	if transition != null and transition.is_running():
		await transition.finished
	
	transition = create_tween()
	
	if curvalclamped < xp_bar.scale.x:
		transition.tween_property(xp_bar,"scale",Vector2(1,1),0.2)
		transition.tween_property(xp_bar,"scale",Vector2(0,1),0)
	transition.tween_property(xp_bar,"scale",Vector2(curvalclamped,1),0.2)
	transition.play()
	#xp_bar.scale.x = curvalclamped

	#print("xp changed to: "+str(xpAttribute.current_value)+" scaled: "+str(xpAttribute.get_value_scaled())+" clamped: "+str(curvalclamped)+"\n")

func _on_xp_maxed(attr,_info):
	var xpAttribute = attr
	xpAttribute.current_value -= xpAttribute.max_value
	level += 1
	xpAttribute.max_value = round((pow(level, 2.3) + level * 4) * 10)
	xp_bar.scale.x = 0
	Global.open_pause_panel(to_open_ui_panel.instantiate())
