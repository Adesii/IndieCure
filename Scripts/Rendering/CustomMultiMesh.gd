class_name CustomMultiMesh
extends Node2D

var arr: Array[MeshInstance2D] = []
var arr_shadows: Array[MeshInstance2D] = []
var _active_count := 0
var instance_count: int:
	get:
		return _active_count
	set(value):
		if value > actual_instances:
			for i in range(value - actual_instances):
				add_new()
		elif value < actual_instances:
			#hide instances at the back but don't free them
			for i in range(actual_instances - value):
				var ind = arr.size() - i - 1
				arr[ind].hide()
				if archetype.shadow:
					arr_shadows[ind].hide()
		_active_count = value

var actual_instances: int = 0

var quad_mesh: QuadMesh = QuadMesh.new()
var enemy_material: ShaderMaterial = preload("uid://wltc7yq4i340")
var archetype: MultiRenderItem

func _init(size: int = 32):
	quad_mesh.size = Vector2(size, size)
	quad_mesh.material = enemy_material
	y_sort_enabled = true
	pass

func add_new():
	if actual_instances > _active_count:
		return
	var mi: MeshInstance2D = MeshInstance2D.new()
	quad_mesh.center_offset = Vector3(-archetype.image_offset.x, -archetype.image_offset.y, 0)
	mi.mesh = quad_mesh
	mi.material = enemy_material
	mi.texture = archetype.framesstrip
	mi.y_sort_enabled = true
	mi.visible = false
	arr.append(mi)
	if archetype.shadow:
		var mi_shadow := mi.duplicate()
		mi_shadow.y_sort_enabled = false
		arr_shadows.append(mi_shadow)
		Global.shadow_canvas_group.call_deferred("add_child", mi_shadow)
	Global.current_scene.call_deferred("add_child", mi) # TODO: Figure out if this is needed or if there is another way to do Y-Sorting properly
	actual_instances += 1

func update_instance(index: int, enemy: AnimatedMassObject):
	if index < 0 or index >= instance_count:
		return
	var mi = arr[index]
	mi.transform = enemy.transform
	mi.reset_physics_interpolation()
	mi.set_instance_shader_parameter("fliph", enemy.flip_h if !archetype.default_flip_h else not enemy.flip_h) # TODO: Figure out how to pass this data efficiently
	mi.set_instance_shader_parameter("framecount", enemy.archetype.framesstrip.get_width() / enemy.archetype.image_size.x) # TODO: Figure out how to pass this data efficiently
	mi.set_instance_shader_parameter("frame", enemy.image_offset_animation) # TODO: Figure out how to pass this data efficiently
	mi.modulate = enemy.modulate

	if enemy.archetype.shadow:
		var mi_shadow = arr_shadows[index]
		mi_shadow.transform = enemy.transform.translated(Vector2(0, -2))
		mi_shadow.scale = Vector2(1, -1.0)

		mi_shadow.reset_physics_interpolation()
		mi_shadow.set_instance_shader_parameter("fliph", enemy.flip_h if !archetype.default_flip_h else not enemy.flip_h) # TODO: Figure out how to pass this data efficiently
		mi_shadow.set_instance_shader_parameter("framecount", enemy.archetype.framesstrip.get_width() / enemy.archetype.image_size.x) # TODO: Figure out how to pass this data efficiently
		mi_shadow.set_instance_shader_parameter("frame", enemy.image_offset_animation) # TODO: Figure out how to pass this data efficiently
	#mi_shadow.modulate = enemy.modulate


	if !mi.visible:
		await get_tree().physics_frame
		mi.call_deferred("show")
		if enemy.archetype.shadow:
			var mi_shadow = arr_shadows[index]
			mi_shadow.call_deferred("show")

func update_static_instance(index: int, object: MassObject):
	if index < 0 or index >= instance_count:
		return
	
	var mi = arr[index]
	mi.transform = object.transform
	mi.reset_physics_interpolation()
	mi.modulate = Color.WHITE
	if !mi.visible:
		await get_tree().physics_frame
		mi.call_deferred("show")


func remove_instance(index: int):
	if index < 0 or index >= instance_count:
		return
	var mi: MeshInstance2D = arr[index]
	mi.queue_free()
	if archetype.shadow:
		var mi_shadow: MeshInstance2D = arr_shadows[index]
		mi_shadow.queue_free()
		arr_shadows.remove_at(index)
	arr.remove_at(index)
