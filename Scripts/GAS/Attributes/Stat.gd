extends Node

func Get(obj, attributename: String, subobj=null) -> float:
	if obj.has_method("_get_stat"):
		return obj._get_stat(attributename, subobj)
		
	var statnode: Node = get_stat_node(obj)
		
	return statnode._get_stat(attributename, subobj)

func Get_Attribute(obj, attributename: String, subobj=null) -> Attribute:
	if obj.has_method("_get_attribute"):
		return obj._get_attribute(attributename, subobj)
		
	var statnode: Node = get_stat_node(obj)
		
	return statnode._get_attribute(attributename, subobj)

func Set(obj, attributename: String, value, subobj=null):
	if obj.has_method("_set_stat"):
		return obj._set_stat(attributename, value, subobj)

	var statnode: Node = get_stat_node(obj)

	return statnode._set_stat(attributename, value, subobj)

func Modify(obj, attributename: String, value, modificationoperator, subobj=null):
	if obj.has_method("_modify_stat"):
		return obj._modify_stat(attributename, value, modificationoperator, subobj)

	var statnode: Node = get_stat_node(obj)

	return statnode._modify_stat(attributename, value, modificationoperator, subobj)

func Damage(from, to, subobj=null):
	var basedamage = Get(from, "attack_damage")
	var damage_modifier = Get(from, "damage_modifier")
	#var armor = Get(to, "armor")
	var damage = basedamage # - armor
	if damage < 0:
		damage = 0
	if damage_modifier == 0:
		damage_modifier = 1

	#print("Damage: " + str(damage))
	
	# apply a bit of randomness to the damage
	damage = damage - randf_range(max(2, damage * 0.1), max(5, damage * 0.2))

	#print("Damage after randomness: " + str(damage))

	damage = round(damage * damage_modifier)

	#print("Damage after modifier: " + str(damage))
	damage = abs(damage)

	Modify(to, "health", damage, "-", subobj)

func from_set(obj, attributeset: AttributeSet, subobj=null):
	if attributeset == null:
		print("attributeset is null on :" + str(obj))
		return
	for key in attributeset.attributes:
		Set(obj, key.attribute_name, key.default_value, subobj)

func get_stat_node(obj) -> Node:
	if not obj.has_node("Stats"):
		return add_new_stat_node(obj)
	else:
		return obj.get_node("Stats")

func add_new_stat_node(obj) -> Node:
	var newnode = StatHolderNode.new()
	newnode.set_name("Stats")
	obj.add_child(newnode)
	return newnode

func print(obj, subobj=null):
	print("###################" + str(obj) + "###################")
	# iterate over all attributes and print them in a human readable string
	var statholdernode = obj.get_node("Stats")
	if statholdernode == null:
		print("no stats found on " + str(obj))
		return
	# iterate over all attributes and print them in a human readable string
	for key in statholdernode.statholder.attributes:
		print(key + " : " + str(Get(obj, key, subobj)))
