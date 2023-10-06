extends Control

@export var character_preview : PackedScene
@export var character_previews_container : Control
@export var temp_level : PackedScene

var character_previews = []

signal character_selected(character)

func get_characters():
	var characterspath = ProjectSettings.get_setting("indiecure/CharacterPaths","res://characters/")
	var characters = []
	
	var dir = DirAccess.open(characterspath)
	var directories = dir.get_directories()

	for d in directories:
		# load character resource
		var character = load(characterspath+"/"+ d + "/"+d+".tres")
		characters.append(character)

	
	return characters
func _ready():
	for child in character_previews_container.get_children():
		child.queue_free()
	# load characters and create previews
	var characters = get_characters()
	for c in characters:
		#print(c)
		var preview = character_preview.instantiate()
		preview.character_resource = c
		preview.connect("character_pressed",_on_character_pressed)
		character_previews.append(preview)
		character_previews_container.add_child(preview)

func _on_character_pressed(character):
	# emit signal
	Global.current_character = character
	emit_signal("character_selected",character)


func _on_start_pressed():
	print("start pressed",Global.current_character)
	if Global.current_character:
		#get_tree().change_scene("res://scenes/level.tscn")
		Global.load_stage(temp_level)
	else:
		print("no character selected")
