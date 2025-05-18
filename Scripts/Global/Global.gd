extends Node

var current_character: IndieCharacter = load("res://Characters/Anny/Anny.tres")
var ingame_ui: PackedScene = load("res://Scenes/Global/ingame_ui.tscn")
var xp_drops: PackedScene = load("res://Scripts/Global/xp_drop.tscn")

var scene_directory: SceneDirectory = preload("uid://bsg3mk3myx3hi")

var player: CharacterBody2D
var player_camera: PhantomCamera2D
var ui: CanvasLayer

var shadow_canvas_group: CanvasGroup

var xp_drop_node: XPDrop

var current_scene = null
var main_camera: Camera2D
var phantom_host: PhantomCameraHost

var attack_direction = Vector2(1, 0)


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	if get_tree().current_scene is Control:
		return
	shadow_canvas_group = load("res://Scripts/Global/ShadowGroup.tscn").instantiate()

	current_scene = get_tree().current_scene
	
	setup_player()
	setup_rest()

	current_scene.add_child(shadow_canvas_group)

func _input(event):
	#just close the game if esc is pressed until a pause menu is implemented
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()

func load_stage(stage_scene: PackedScene):
	var oldscene = current_scene
	var stage = stage_scene.instantiate()

	current_scene = stage

	shadow_canvas_group = load("res://Scripts/Global/ShadowGroup.tscn").instantiate()
	current_scene.add_child(shadow_canvas_group)
	
	get_tree().root.add_child(stage)

	#add character scene
	setup_player()
	setup_rest()

	oldscene.queue_free()

func setup_player():
	var player_scene = load("uid://byco3pvydnl2q").instantiate() as Node;
	player = player_scene.get_node("Player")
	player.get_node("PlayerSprite").set("sprite_frames", current_character.character_animations)
	Stat.from_set(player, current_character.attribute_set)
	var childs = player_scene.get_children()
	for add_ins in childs:
		player_scene.remove_child(add_ins)
		current_scene.add_child(add_ins)
		if add_ins is Camera2D:
			main_camera = add_ins as Camera2D
			phantom_host = main_camera.get_child(0)
		print("adding " + str(add_ins))
	
	player.character = current_character
	player_camera = player.get_node("Camera")

	var ingameui = ingame_ui.instantiate()
	current_scene.add_child(ingameui)
	ui = ingameui

	InputHandler._set_game_state(InputHandler.GameState.IN_GAME)

	phantom_host.pcam_priority_updated(player_camera)

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

func create_timer(time) -> SceneTreeTimer:
	return get_tree().create_timer(time, false, true)

func create_portal_to(scenename: StringName) -> Node:
	var portal = preload("uid://mrl3ss7x67t1").instantiate()
	portal.portal_destination = scenename
	current_scene.add_child(portal)

	#spawn it around the player within a certain radius
	var random_angle = randf() * 2 * PI
	var random_radius = randf() * 50 + 50
	var position = Vector2(random_radius * cos(random_angle), random_radius * sin(random_angle))
	portal.global_transform.origin = player.global_transform.origin + position
	return portal

func change_scene(scenename: StringName) -> void:
	load_stage(scene_directory.directoryMap[scenename])
