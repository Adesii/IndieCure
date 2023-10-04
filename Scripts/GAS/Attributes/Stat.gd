extends Node

func get_stat(obj,attributename : String,subobj = null):
	if obj.has_method("_get_stat"):
		return obj._get_stat(attributename,subobj)
		
	var statnode :Node
	if not obj.has_node("Stats"):
		statnode = add_new_stat_node(obj)
	else:
		statnode = obj.get_node("Stats")
		
	return statnode._get_stat(attributename,subobj)

func set_stat(obj,attributename : String,value,subobj = null):
	if obj.has_method("_set_stat"):
		return obj._set_stat(attributename,value,subobj)

	var statnode :Node
	if not obj.has_node("Stats"):
		statnode = add_new_stat_node(obj)
	else:
		statnode = obj.get_node("Stats")

	return statnode._set_stat(attributename,value,subobj)

func modify_stat(obj,attributename : String,value,modificationoperator,subobj = null):
	if obj.has_method("_modify_stat"):
		return obj._modify_stat(attributename,value,modificationoperator,subobj)
	var statnode :Node
	if not obj.has_node("Stats"):
		statnode = add_new_stat_node(obj)
	else:
		statnode = obj.get_node("Stats")

	return statnode._modify_stat(attributename,value,modificationoperator,subobj)

func from_set(obj,attributeset : AttributeSet,subobj = null):
	if attributeset == null:
		print("attributeset is null on :"+str(obj))
		return
	for key in attributeset.attributes:
		set_stat(obj,key.attribute_name,key.default_value,subobj)


func add_new_stat_node(obj) -> Node:
	var newnode = StatHolderNode.new()
	newnode.set_name("Stats")
	obj.add_child(newnode)
	return newnode
