extends Node


var current_character : IndieCharacter

var player : CharacterBody2D

var current_scene = null
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func _input(event):
	#just close the game if esc is pressed until a pause menu is implemented
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()
		

func load_stage(stage_scene : PackedScene):
	var oldscene = current_scene
	var stage = stage_scene.instantiate()

	current_scene = stage

	
	get_tree().root.add_child(stage)
	#get_tree().current_scene = stage
	
	#add character scene
	var player_scene = current_character.character_scene.instantiate();
	current_scene.add_child(player_scene)

	player = player_scene

	oldscene.queue_free()
