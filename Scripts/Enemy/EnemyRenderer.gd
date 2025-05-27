extends RefCounted
class_name EnemyRenderer


var baseNode: Node

#ar multi_mesh_dictionary: Dictionary[EnemyArchetype, MultiMeshInstance2D]
#ar mesh_dictionary: Dictionary[EnemyArchetype, MultiMesh]

var custom_dictionary: Dictionary[EnemyArchetype, CustomMultiMesh]

var index_dictionary: Dictionary[EnemyArchetype, int]

var material: ShaderMaterial = preload("uid://wltc7yq4i340")


func _init(base_node: Node) -> void:
	baseNode = base_node


func add_enemy(enemy_type: EnemyArchetype):
	#print("Adding enemy type %s" % str(enemy_type))
	if !custom_dictionary.has(enemy_type):
		var cmi = CustomMultiMesh.new()
		cmi.archetype = enemy_type
		baseNode.add_child(cmi)
		cmi.instance_count = 1
		custom_dictionary[enemy_type] = cmi
		index_dictionary[enemy_type] = 0
	else:
		var mmi: CustomMultiMesh = custom_dictionary[enemy_type]
		mmi.instance_count += 1

func remove_enemy(enemy_type: EnemyArchetype):
	if custom_dictionary.has(enemy_type):
		var mmi: CustomMultiMesh = custom_dictionary[enemy_type]
		if mmi.instance_count > 0:
			mmi.instance_count -= 1
	else:
		push_warning("Cannot remove enemy type that does not exist in dictionary.")

func reset_index():
	for key in index_dictionary.keys():
		index_dictionary[key] = 0


func update_enemy(enemy: AnimatedMassObject):
	if index_dictionary.has(enemy.archetype):
		var index = index_dictionary[enemy.archetype]
		var mmi_mesh: CustomMultiMesh = custom_dictionary[enemy.archetype]
		mmi_mesh.call_deferred("update_instance", index, enemy)
		#mmi_mesh.update_instance(index, enemy)
		#mmi_mesh.call_deferred("set_instance_custom_data", index, enemy.custom_data)
		index_dictionary[enemy.archetype] += 1
	else:
		push_warning("Cannot update enemy type that does not exist in dictionary.")
