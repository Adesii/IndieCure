extends Control
class_name  stat_editor_control

var controls = preload("res://addons/custominspectors/stat_editor/stat_editor_control.tscn")

var controls_instance = null

var line : LineEdit = null
var option : OptionButton = null
var number : NumberBox = null

var has_modifier = false

signal updated

var statobject

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_minimum_size = Vector2(0, 50)
	controls_instance = controls.instantiate()
	add_child(controls_instance)

	line = controls_instance.get_node("LineEdit")
	option = controls_instance.get_node("OptionButton")
	number = controls_instance.get_node("NumberValue")

	line.text_changed.connect(_on_text_changed)
	option.connect("item_selected",_on_option_selected)
	number.value_changed.connect(_on_number_value_changed)

func _on_text_changed(text):
	updateall()

func _on_option_selected(id):
	updateall()

func _on_number_value_changed(a,b):
	updateall()

func updateall():
	statobject.attribute_name = line.text
	
	if has_modifier:
		statobject.modifier = option.selected
		statobject.amount = number.value
	else:
		statobject.default_value = number.value

	updated.emit()


func update():
	#print(statobject)
	line.text = statobject.attribute_name
	if statobject is StatUpgradeResource:
		option.selected = statobject.modifier
		number.set_value(statobject.amount)
		has_modifier = true
	else:
		number.set_value(statobject.default_value)
		option.hide()
		has_modifier = false