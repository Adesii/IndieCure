extends Panel


@onready var backgroundSprite: TextureRect = $background
@onready var itemSprite: TextureRect = $CenterContainer/Panel/item

func update(item: InventoryItem):
	if !item:
		backgroundSprite.visible = true
		itemSprite.visible = false
	else:
		backgroundSprite.visible = false
		itemSprite.visible = true
		itemSprite.texture = item.texture
