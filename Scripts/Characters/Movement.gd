extends CharacterBody2D

const JUMP_VELOCITY = -400.0
@export var inventory: Inventory

func _ready():
	inventory.item_added.connect(on_item_added)

func _physics_process(_delta):
	# Handle Jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var updirection :float =Input.get_axis("move_up", "move_down")
	var direction :float = Input.get_axis("move_left", "move_right")
	var wishvelocity :Vector2 = Vector2(direction, updirection)
	wishvelocity = wishvelocity.normalized() * Stat.Get(self, "movement_speed")

	# Move the character.
	velocity = velocity.lerp(wishvelocity, 0.6)

	move_and_slide()


func _on_pick_up_area_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)

func on_item_added(item:InventoryItem):
	print("Item added: ", item.name)
	if item.scene != null:
		add_child(item.scene.instantiate())
		print("scene added for item: ", item.name)