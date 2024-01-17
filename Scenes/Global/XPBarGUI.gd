extends Control

@export var xp_bar : Control
@export var lvl_text : RichTextLabel

@export var to_open_ui_panel : PackedScene

var level : int = 1

var level_req : float = 100

var accounted_xp : float = 0
var current_xp : float = 0

var transition : Tween

var xpattribute : Attribute




func _ready():
	var xxpAttribute = Stat.Get_Attribute(Global.player, "xp")
	xpattribute = xxpAttribute
	xpattribute.max_value = round((pow(level, 1.8) + level * 4)*10)
	level_req = round((pow(level, 1.8) + level * 4)*10)
	#xpattribute.value_changed.connect(_on_xp_changed)
	#xpAttribute.value_maxed.connect(_on_xp_maxed)
	xp_bar.scale.x = 0

func _process(delta: float) -> void:
	current_xp = xpattribute.get_value()
	if get_tree().paused:
		return
	lvl_text.text ="lvl: "+ str(level) + "\nXP: " + str(current_xp) + " / "+ str(xpattribute.max_value)
	accounted_xp = lerp(accounted_xp,current_xp,10*delta)
	if current_xp-accounted_xp < 0.1:
		accounted_xp = current_xp

	#print("accounted xp: "+str(accounted_xp)+" current xp: "+str(current_xp)+"\n")
	#print("level req: "+str(level_req)+"\n")
	
	if roundf(accounted_xp) >= level_req:
		_on_xp_maxed()

	
	xp_bar.scale.x = accounted_xp / level_req

func _on_xp_maxed():
	level += 1
	var xpAttribute = Stat.Get_Attribute(Global.player, "xp")
	accounted_xp = 0
	xpAttribute.current_value -= level_req
	level_req = round((pow(level, 2.3) + level * 4) * 10)
	xpAttribute.max_value = level_req
	var panel = to_open_ui_panel.instantiate()
	Global.open_pause_panel(panel)
