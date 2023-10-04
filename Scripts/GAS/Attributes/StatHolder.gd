extends RefCounted
class_name StatHolder

# A generic Node that holds every attribute and manages it for the parent node

var attributes : Dictionary = {}

@export var default_attribute_set : AttributeSet

var owner_info

func _init(owner):
	owner_info = owner

func _ready():
	if default_attribute_set != null :
		Stat.from_set(self, default_attribute_set)

func _get_stat(attributename):
	if attributes.has(attributename):
		return attributes[attributename].get_value()
	
	push_warning("StatHolder: Attribute " + attributename + " not found")
	return 0

func _get_attribute(attributename):
	if attributes.has(attributename):
		return attributes[attributename]
	
	push_warning("StatHolder: Attribute " + attributename + " not found")
	return null


func _set_stat(attributename, value):
	if attributes.has(attributename):
		attributes[attributename].set_value(value)
	else:
		attributes[attributename] = Attribute.new(value,owner_info,attributename)
	
	return attributes[attributename]

func _modify_stat(attributename,value,modificationoperator):
	if attributes.has(attributename):
		attributes[attributename].modify_value(value,modificationoperator)
	else:
		attributes[attributename] = Attribute.new(value,owner_info,attributename)

	return attributes[attributename]
