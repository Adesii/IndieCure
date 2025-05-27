class_name CustomMultiMesh
extends Node2D

var arr: Array[MeshInstance2D] = []
var instance_count: int:
    get:
        return len(arr)
    set(value):
        if value > len(arr):
            for i in range(value - len(arr)):
                add_new()
        elif value < len(arr):
            for i in range(len(arr) - value):
                arr.pop_back().queue_free()

        
var quad_mesh: QuadMesh = QuadMesh.new()
var enemy_material: ShaderMaterial = preload("uid://wltc7yq4i340")
var archetype: EnemyArchetype


func _init():
    quad_mesh.size = Vector2(32, 32)
    quad_mesh.material = enemy_material
    y_sort_enabled = true
    pass

func add_new():
    var mi: MeshInstance2D = MeshInstance2D.new()
    quad_mesh.center_offset = Vector3(-archetype.image_offset.x, -archetype.image_offset.y, 0)
    mi.mesh = quad_mesh
    mi.material = enemy_material
    mi.texture = archetype.framesstrip
    mi.y_sort_enabled = true
    mi.visible = false
    arr.append(mi)
    get_parent().get_parent().call_deferred("add_child", mi) # TODO: Figure out if this is needed or if there is another way to do Y-Sorting properly

func update_instance(index: int, enemy: AnimatedMassObject):
    if index < 0 or index >= instance_count:
        return
    var mi = arr[index]
    mi.transform = enemy.transform
    mi.reset_physics_interpolation()
    mi.set_instance_shader_parameter("fliph", enemy.flip_h) # TODO: Figure out how to pass this data efficiently
    mi.set_instance_shader_parameter("framecount", enemy.archetype.framesstrip.get_width() / enemy.archetype.image_size.x) # TODO: Figure out how to pass this data efficiently
    mi.set_instance_shader_parameter("frame", enemy.image_offset_animation) # TODO: Figure out how to pass this data efficiently
    mi.modulate = enemy.modulate

    if !mi.visible:
        await get_tree().physics_frame
        mi.call_deferred("show")


func remove_instance(index: int):
    if index < 0 or index >= instance_count:
        return
    var mi: MeshInstance2D = arr[index]
    mi.queue_free()
    arr.remove_at(index)
