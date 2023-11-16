extends RefCounted
class_name MassRenderer

var _objects: Array[MassObject]

var _canvas_item_rid : RID
var _canvas_item_shadow_rid : RID


var rendering_threads = 4
var rendering_threads_array : Array[Thread]

func _init():
	_canvas_item_rid = RenderingServer.canvas_item_create()
	_canvas_item_shadow_rid = RenderingServer.canvas_item_create()

	for i in rendering_threads:
		rendering_threads_array.append(Thread.new())

func free():
	RenderingServer.free_rid(_canvas_item_rid)
	RenderingServer.free_rid(_canvas_item_shadow_rid)


func add_object(mass_object: MassObject):
	#_capacity = _objects.size()
	#if _objectcount + 1 >= _capacity:
	_objects.append(mass_object)
	#_objectcount += 1
	return _objects.size() - 1
		

	#for i in _objects.size():
	#	if _objects[i] == null:
	#		_objects[i] = mass_object
	#		_objectcount += 1
	#		return i

func remove_object(index : MassObject):
	var mass_object = index
	
	if mass_object.rendering_rid.is_valid():
		RenderingServer.free_rid(mass_object.rendering_rid)
	if mass_object.has_shadow and mass_object.rendering_shadow_rid.is_valid():
		RenderingServer.free_rid(mass_object.rendering_shadow_rid)
	if mass_object.physics_rid.is_valid():
		PhysicsServer2D.free_rid(mass_object.physics_rid)

	_objects.erase(mass_object)
	#print_debug("MassRenderer: Object not found")

func remove_object_at(index : int):
	if index >= _objects.size():
		return
	var mass_object = _objects[index]
	remove_object(mass_object)
	return mass_object

func end_render(): # multithreading rendering
	var count = ceil(float(_objects.size()) / rendering_threads)
	if count == 0:
		return
	for i in rendering_threads:
		var t = rendering_threads_array[i]
		if t.is_alive():
			continue
		if t.is_started():
			t.wait_to_finish()
		t.start(draw_batch.bind( i * count, count))
		#print("MassRenderer: Thread " + str(i) + " started, for range: " + str(i * count) + " to " + str(i * count + count))

	#for i in rendering_threads:
	#	var t = rendering_threads_array[i]
	#	t.wait_to_finish()


func draw_batch(offset, count):
	for i in count:
		if !_objects.size() > i + offset:
			continue
		var _obj = _objects[i + offset]
		if _obj != null:
			_draw_single(_obj)

func _draw_single(obj: MassObject):
	RenderingServer.canvas_item_clear(obj.rendering_rid)
	RenderingServer.canvas_item_set_transform(obj.rendering_rid, obj.transform)
	obj.texture.draw_rect(obj.rendering_rid, obj.texture_rect ,false,obj.modulate)

	if !obj.has_shadow:
		return
	RenderingServer.canvas_item_set_transform(obj.rendering_shadow_rid, obj.transform)
	RenderingServer.canvas_item_clear(obj.rendering_shadow_rid)
	obj.texture.draw_rect(obj.rendering_shadow_rid, obj.shadow_texture_rect ,false)

