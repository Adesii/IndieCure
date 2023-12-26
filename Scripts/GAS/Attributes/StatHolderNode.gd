extends Node
class_name StatHolderNode

var statholder : StatHolder = StatHolder.new(self)

@export var starting_attributes : Array[AttributePair]

func _ready():
	for attribute in starting_attributes:
		statholder._set_stat(attribute.attribute_name,attribute.default_value)

func _get_stat(attributename,_subobj = null):
	return statholder._get_stat(attributename)

func _get_attribute(attributename,_subobj = null):
	return statholder._get_attribute(attributename)
func _set_stat(attributename, value,_subobj = null):
	return statholder._set_stat(attributename, value)

func _modify_stat(attributename,value,modificationoperator,_subobj = null):
	return statholder._modify_stat(attributename,value,modificationoperator)
