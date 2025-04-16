extends CharacterBody2D

const JUMP_VELOCITY = -400.0
@export var inventory: Inventory

@onready var move_action: GUIDEAction = preload("uid://i341h3c18r7d")
@onready var aim_mode_action = preload("uid://b84mupd5fpg4l")

var character: IndieCharacter:
	set(val):
		character = val
		init_character()

var mouse_input = false

func _ready() -> void:
	if !inventory.item_added.is_connected(on_item_added):
		inventory.item_added.connect(on_item_added)
	
	aim_mode_action.triggered.connect(func() -> void:
		mouse_input = not mouse_input
	)

func init_character():
	if !inventory.item_added.is_connected(on_item_added):
		inventory.item_added.connect(on_item_added)
	if character != null:
		for item in character.starter_equipment:
			inventory.insert(item)
			print("Item added: ", item.name)
	print("Character initialized")

func _physics_process(_delta):
	var updirection: float = move_action.value_axis_2d.y
	var direction: float = move_action.value_axis_2d.x
	var wishvelocity: Vector2 = Vector2(direction, updirection)
	wishvelocity = wishvelocity.limit_length() * Stat.Get(self, "movement_speed")

	# scale the velocity based on strenghth of input


	# Move the character.
	velocity = velocity.lerp(wishvelocity, 0.6)

	#if aim_mode_action.is_triggered():
	#	mouse_input = not mouse_input

	# handle attack direction
	if mouse_input:
		var mouse_pos = get_global_mouse_position()
		var attackdirection = mouse_pos - global_position
		attackdirection = attackdirection.normalized()
		Global.attack_direction = attackdirection
	else:
		if velocity.length() > 0.1:
			Global.attack_direction = velocity.normalized()

	RenderingServer.global_shader_parameter_set("player_pos", global_position)
	move_and_slide()

func _on_pick_up_area_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)

func on_item_added(item: InventoryItem):
	print("Item added: ", item.name)
	if item.scene != null:
		var nod = item.scene.instantiate()
		item.instance = nod
	
		if item.stats != null:
			var keys = item.stats
			for key in keys:
				Stat.Set(nod, key.attribute_name, key.default_value)
				print(Stat.Get(nod, key.attribute_name))
				print("stat added for item: ", item.name)

		add_child(nod)
		print("scene added for item: ", item.name)

	if item.stat_upgrades != null:
		for upgrade in item.stat_upgrades:
			upgrade.apply(self)
			print(Stat.Get(self, upgrade.attribute_name))
