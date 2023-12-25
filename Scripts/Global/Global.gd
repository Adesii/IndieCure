extends Node


var current_character : IndieCharacter = load("res://Characters/Anny/Anny.tres")
var ingame_ui : PackedScene = load("res://Scenes/Global/ingame_ui.tscn")
var xp_drops : PackedScene = load("res://Scripts/Global/xp_drop.tscn")

var player : CharacterBody2D
var ui : CanvasLayer

var shadow_canvas_group : CanvasGroup

var xp_drop_node : XPDrop

var current_scene = null
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	if get_tree().current_scene is Control:
		return
	shadow_canvas_group = load("res://Scripts/Global/ShadowGroup.tscn").instantiate()

	current_scene = get_tree().current_scene
	
	setup_player()

	current_scene.add_child(shadow_canvas_group)

	
	

func _input(event):
	#just close the game if esc is pressed until a pause menu is implemented
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()
		

func load_stage(stage_scene : PackedScene):
	var oldscene = current_scene
	var stage = stage_scene.instantiate()

	current_scene = stage

	shadow_canvas_group = load("res://Scripts/Global/ShadowGroup.tscn").instantiate()
	current_scene.add_child(shadow_canvas_group)

	
	get_tree().root.add_child(stage)

	
	#get_tree().current_scene = stage
	
	#add character scene
	setup_player()
	setup_rest()

	oldscene.queue_free()


func setup_player():
	var player_scene = load("res://Characters/PlayerScene.tscn").instantiate();
	player = player_scene
	player.get_node("PlayerSprite").set("sprite_frames", current_character.character_animations)
	Stat.from_set(player,current_character.attribute_set)
	current_scene.add_child(player)

	var ingameui = ingame_ui.instantiate()
	current_scene.add_child(ingameui)
	ui = ingameui

func setup_rest():
	if xp_drop_node != null:
		return
	xp_drop_node = xp_drops.instantiate()
	current_scene.add_child(xp_drop_node)


func open_pause_panel(panel):
	if panel.has_signal("close"):
		panel.connect("close", close_pause_panel)
	
	ui.add_child(panel)
	get_tree().paused = true


func close_pause_panel(panel):
	#panel.close.emit()
	panel.queue_free()
	get_tree().paused = false


func is_in_game():
	return get_tree().current_scene is WavesController
