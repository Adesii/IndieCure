extends Node2D
class_name EnemySpawner


@export var frames : Array[Texture2D]
@export var image_offset : Vector2i
@export var image_change_offset = 0.2

@export var shared_area : Area2D

@onready var max_images = frames.size()


var enemies : Array[Enemy] = []
var enemyCanvas : Array[RID] = []

func _ready():
	# spawn 600 enemies around 0,0 with a speed of 200 
	for i in range(0, 1500):
		spawn_enemy(Vector2(randf_range(-1000,1000),randf_range(-1000,1000))+Vector2(100,100), 32)


func _exit_tree():
	for enemy in enemies:
		PhysicsServer2D.free_rid(enemy.shape_id)
		RenderingServer.free_rid(enemy.canvas_id)
	enemies.clear()

func _physics_process(delta):
	var used_transform = Transform2D()

	for  i in range(0, enemies.size()):
		var enemy = enemies[i]
		var movement_vector =  Global.player.global_position - enemy.current_position
		var offset : Vector2 = (movement_vector.normalized()*enemy.speed*delta)

		enemy.animation_lifetime += delta

		enemy.velocity = offset

		#var collisiongroupresult =CollisionAvoidance.handle_collisiongroup(enemy,enemy.positionkey)
		#if collisiongroupresult.cellfull:
		#	continue
		#enemy.positionkey = collisiongroupresult.last_position_key
		#var collisionresult = CollisionAvoidance.avoid_others(enemy,enemy.positionkey,32)
		#enemy.velocity += collisionresult *1

		#move the enemy
		enemy.current_position += enemy.velocity
		enemy.global_position = enemy.current_position
		used_transform.origin = enemy.current_position
		PhysicsServer2D.area_set_shape_transform(
			shared_area.get_rid(), i, used_transform
		)
	queue_redraw()
		#animate
		
#func _process(delta):
#	_customdraw()

func _draw():
	_customdraw()
	return
	var offset = frames[0].get_size()/2
	
	#for i in range(0, enemies.size()):
	#	var enemy = enemies[i]
	#	var sizeoffset = Vector2(frames[enemy.image_offset].get_size().x,-frames[enemy.image_offset].get_size().y)
	#	draw_texture_rect(
	#		frames[enemy.image_offset], 
	#		Rect2(enemy.current_position - offset - (Vector2(image_offset))+Vector2(0,-sizeoffset.y),sizeoffset),
	#		false,
	#		Color(0,0,0,0.5)
	#	)
	for i in range(0, enemies.size()):
		var enemy = enemies[i]
		if enemy.animation_lifetime >= image_change_offset:
			enemy.image_offset += 1
			enemy.animation_lifetime = 0
			if enemy.image_offset >= max_images:
				enemy.image_offset = 0
		draw_texture(
			frames[enemy.image_offset], 
			enemy.current_position - offset - (Vector2(image_offset))
		)
func _customdraw():
	var offset = frames[0].get_size()/2
	

	for i in range(0, enemies.size()):
		var enemy = enemies[i]
		if enemy.animation_lifetime >= image_change_offset:
			enemy.image_offset += 1
			enemy.animation_lifetime -= image_change_offset 
			if enemy.image_offset >= max_images:
				enemy.image_offset = 0
		
		RenderingServer.canvas_item_clear(enemy.canvas_id)
		RenderingServer.canvas_item_set_parent(enemy.canvas_id, get_parent().get_canvas_item())
		RenderingServer.canvas_item_set_transform(enemy.canvas_id, Transform2D(0, enemy.current_position+Vector2(image_offset.x,0)))
		var atlastexture = frames[enemy.image_offset] as AtlasTexture
		atlastexture.draw(enemy.canvas_id,-offset-Vector2(0,image_offset.y))
	
func spawn_enemy(spawn_location : Vector2,speed = 200) ->void:
	var enemy = Enemy.new()
	enemy.current_position = spawn_location
	enemy.global_position = spawn_location
	enemy.speed = speed

	enemy.image_offset = randi() % max_images
	enemy.animation_lifetime = randf_range(0,1)

	_configure_collision_for_enemy(enemy)

	enemy.canvas_id = RenderingServer.canvas_item_create()
	


	enemies.append(enemy)


func _configure_collision_for_enemy(enemy:Enemy) -> void:
	# Define the shape's position
	var used_transform := Transform2D(0, position)
	used_transform.origin = enemy.current_position
	# Create the shape
	var _circle_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(_circle_shape, 8)

	# Add the shape to the shared area
	PhysicsServer2D.area_add_shape(
		shared_area.get_rid(), _circle_shape, used_transform
	)
	
	# Register the generated id to the bullet
	enemy.shape_id = _circle_shape
