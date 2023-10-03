extends RefCounted
class_name StatHolder

# A generic Node that holds every attribute and manages it for the parent node

var attributes : Dictionary = {}

@export var default_attribute_set : AttributeSet

var owner_info

func _init(owner):
	owner_info = owner

func _ready():
	if default_attribute_set :
		Stat.from_set(self, default_attribute_set)

func _get_stat(attributename):
	return attributes[attributename].get_value()

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
