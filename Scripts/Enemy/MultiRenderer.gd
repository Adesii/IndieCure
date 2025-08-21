extends RefCounted
class_name MultiRenderer


var baseNode: Node

#ar multi_mesh_dictionary: Dictionary[StringName, MultiMeshInstance2D]
#ar mesh_dictionary: Dictionary[StringName, MultiMesh]

var custom_dictionary: Dictionary[MultiRenderItem, CustomMultiMesh]

var index_dictionary: Dictionary[MultiRenderItem, int]

var material: ShaderMaterial = preload("uid://wltc7yq4i340")


func _init(base_node: Node) -> void:
	baseNode = base_node


func add_item(key: MultiRenderItem):
	#print("Adding enemy type %s" % str(enemy_type))
	if !custom_dictionary.has(key):
		var cmi = CustomMultiMesh.new(key.object_size)
		cmi.archetype = key
		baseNode.add_child(cmi)
		cmi.instance_count = 1
		custom_dictionary[key] = cmi
		index_dictionary[key] = 0
	else:
		var mmi: CustomMultiMesh = custom_dictionary[key]
		mmi.instance_count += 1

func remove_item(key: MultiRenderItem):
	if custom_dictionary.has(key):
		var mmi: CustomMultiMesh = custom_dictionary[key]
		if mmi.instance_count > 0:
			mmi.instance_count -= 1
	else:
		push_warning("Cannot remove enemy type that does not exist in dictionary.")

func reset_index():
	for key in index_dictionary.keys():
		index_dictionary[key] = 0


func update_enemy(enemy: MassObject):
	if index_dictionary.has(enemy.archetype):
		var index = index_dictionary[enemy.archetype]
		var mmi_mesh: CustomMultiMesh = custom_dictionary[enemy.archetype]
		if enemy is AnimatedMassObject:
			mmi_mesh.call_deferred("update_instance", index, enemy)
		else:
			mmi_mesh.call_deferred("update_static_instance", index, enemy)
			
			#mmi_mesh.update_instance(index, enemy)
		#mmi_mesh.call_deferred("set_instance_custom_data", index, enemy.custom_data)
		index_dictionary[enemy.archetype] += 1
	else:
		push_warning("Cannot update enemy type that does not exist in dictionary.")
