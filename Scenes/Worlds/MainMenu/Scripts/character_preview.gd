extends Button


@export var textNode : RichTextLabel
@export var iconNode : TextureRect

var character_resource : IndieCharacter : set = character_resource_set

signal character_pressed(character_resource : IndieCharacter)


func character_resource_set(value):
	character_resource = value
	var filename = value.resource_path.get_file().get_basename()
	textNode.bbcode_text = "[center]" + filename + "[/center]"
	iconNode.texture = value.icon

func _on_pressed():
	print("pressed ",character_resource)
	emit_signal("character_pressed", character_resource)
