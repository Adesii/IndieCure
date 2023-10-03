extends Panel


@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item

func update(item: InventoryItem):
	if !item:
		backgroundSprite.visible = true
		itemSprite.visible = false
	else:
		backgroundSprite.visible = false
		itemSprite.visible = true
		itemSprite.texture = item.texture
