extends CharacterBody2D

const JUMP_VELOCITY = -400.0
@export var inventory: Inventory

var _character: IndieCharacter

var character: IndieCharacter:
	set(val):
		_character = val
		init_character()
	get:
		return _character

var mouse_input = false

func _ready() -> void:
	if !inventory.item_added.is_connected(on_item_added):
		inventory.item_added.connect(on_item_added)

func init_character():
	if !inventory.item_added.is_connected(on_item_added):
		inventory.item_added.connect(on_item_added)
	if character != null:
		for item in character.starter_equipment:
			inventory.insert(item)
			print("Item added: ", item.name)
	print("Character initialized")

func _physics_process(_delta):
	# Handle Jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var updirection: float = Input.get_axis("move_up", "move_down")
	var direction: float = Input.get_axis("move_left", "move_right")
	var wishvelocity: Vector2 = Vector2(direction, updirection)
	wishvelocity = wishvelocity.normalized() * Stat.Get(self, "movement_speed")

	# Move the character.
	velocity = velocity.lerp(wishvelocity, 0.6)

	if Input.is_action_just_pressed("switch_attack_mode"):
		mouse_input = not mouse_input

	# handle attack direction
	if mouse_input:
		var mouse_pos = get_global_mouse_position()
		var attackdirection = mouse_pos - global_position
		attackdirection = attackdirection.normalized()
		Global.attack_direction = attackdirection
	else:
		if velocity.length() > 0.1:
			Global.attack_direction = velocity.normalized()

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
