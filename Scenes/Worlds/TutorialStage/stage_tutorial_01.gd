extends Node2D

@export var ballon := preload("uid://dsfs8yseoxnrd")
@export_category("Dialogues")
@export var start_dialogue := preload("uid://b0a3nr7mn8k26")
@export var rock_dialogue := preload("uid://dr7xqekv3npkl")
@export var outlook_dialogue := preload("uid://cxta8h7gvkjsd")

@export_category("Map Elements")
@export var item_spawner: Marker2D
@export var phantom_camera: PhantomCamera2D
@export var camera_transition: PhantomCameraTween
@export var outlook_camera: PhantomCamera2D

@export_category("Quest")
@export var quest_resource: QuestResource

var original_tween: PhantomCameraTween
var player_camera_host: PhantomCamera2D
var host: PhantomCameraHost

func _ready():
	#InputHandler.start_cutscene()
	Global.player.get_node("PlayerSprite").animation_override = true
	Global.player.get_node("PlayerSprite").animation = "sleep"

	var dialogue_balloon = ballon.instantiate()
	get_tree().current_scene.add_child(dialogue_balloon)
	dialogue_balloon.start(start_dialogue, "start")
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	player_camera_host = Global.player.get_node("Camera")
	host = Global.main_camera.get_node("PhantomCameraHost")
	original_tween = player_camera_host.tween_resource
	player_camera_host.tween_resource = camera_transition
	await get_tree().process_frame
	phantom_camera.set_priority(0)

	Questify.start_quest(quest_resource.instantiate())

func wakeup():
	Global.player.get_node("PlayerSprite").animation_override = false
	host._tween_elapsed_time = 10000
	player_camera_host.set_tween_resource(original_tween)
	#InputHandler.start_gameplay()


func spawn_item():
	item_spawner.spawn_item()

var has_started_cutscene := false
func start_cutscene_rock(_x):
	if has_started_cutscene:
		return
	has_started_cutscene = true
	var dialogue_balloon = ballon.instantiate()
	get_tree().current_scene.add_child(dialogue_balloon)
	dialogue_balloon.start(rock_dialogue, "start")

var has_started_outlook_cutscene := false
func start_outlook_cutscene(_x):
	if has_started_outlook_cutscene:
		return
	has_started_outlook_cutscene = true
	var dialogue_balloon = ballon.instantiate()
	get_tree().current_scene.add_child(dialogue_balloon)
	dialogue_balloon.start(outlook_dialogue, "start")

func start_outlook_zoom():
	outlook_camera.set_priority(20)
	await outlook_camera.tween_completed

func end_outlook_zoom():
	outlook_camera.set_priority(0)
	await player_camera_host.tween_completed

func start_wave():
	State.sendmessage("wave_begin")
