extends Node
class_name StatHolderNode

var statholder : StatHolder = StatHolder.new(self)




func _get_stat(attributename,_subobj = null):
	return statholder._get_stat(attributename)

func _set_stat(attributename, value,_subobj = null):
	return statholder._set_stat(attributename, value)

func _modify_stat(attributename,value,modificationoperator,_subobj = null):
	return statholder._modify_stat(attributename,value,modificationoperator)
