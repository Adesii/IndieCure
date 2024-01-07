extends Node2D

class_name XPDrop

class xp_drop extends MassObject:
	var amount : float
	var radius : float = 8


var max_xp_per_drop = 1000

@export var shared_area : Area2D

@export var xp_texture : Texture2D


var enemy_drop_amount = 10;

@onready var renderer : MassRenderer = MassRenderer.new()

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	queue_redraw()


func _draw():
	var offset = xp_texture.get_size() / 2
	for i in range(0,renderer._objects.size()):
		var drop = renderer._objects[i]
		if drop == null:
			continue

		drop.texture = xp_texture
		var drawrect = Rect2(0,0,xp_texture.get_width(),xp_texture.get_height())
		drawrect.position = -offset

		drop.texture_rect = drawrect

		drawrect.size.y *= -1
		drawrect.position.y -= drawrect.size.y+2
		drop.shadow_texture_rect = drawrect
	renderer.end_render() # figure out if this is a good idea

func drop_xp(dropposition : Vector2,amount : int):

	var _circle_shape_query = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(_circle_shape_query, 4)

	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape_rid = _circle_shape_query
	query.transform = Transform2D(0, dropposition)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = shared_area.collision_mask

	var result = space.intersect_shape(query,8)
	if result:
		for xpd in result:
			if xpd.collider != shared_area:
				continue
			if renderer._objects.size() > xpd.shape:
				var dropxpd = renderer._objects[xpd.shape]
				if dropxpd.amount + amount > max_xp_per_drop:
					continue
				dropxpd.amount += amount
				dropxpd.global_position =(dropxpd.global_position - dropposition) / 2 + dropposition
				return
			else:
				print("Something went wrong, the shape is not in the renderer")
	
	PhysicsServer2D.free_rid(_circle_shape_query)
	var drop = xp_drop.new()
	drop.global_position = dropposition
	drop.amount = amount
	#drop.has_shadow = true

	drop.rendering_rid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(drop.rendering_rid, get_parent().get_canvas_item())

	drop.rendering_shadow_rid = RenderingServer.canvas_item_create()

	RenderingServer.canvas_item_set_parent(drop.rendering_shadow_rid, Global.shadow_canvas_group.get_canvas_item())

	renderer.add_object(drop)

	var _circle_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(_circle_shape, drop.radius)

	# Add the shape to the shared area
	PhysicsServer2D.area_add_shape(
		shared_area.get_rid(), _circle_shape, drop.transform
	)
	
	# Register the generated id to the bullet
	drop.physics_rid = _circle_shape

	queue_redraw()
	



func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var obj = renderer.remove_object_at(local_shape_index)
	# TODO: add xp to global player... needs a way to get the player later on when multiplayer is a thing

	Stat.Modify(Global.player,"xp",obj.amount,"+")
