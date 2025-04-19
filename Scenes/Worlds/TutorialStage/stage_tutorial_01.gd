extends Node2D

@export var ballon := preload("uid://dsfs8yseoxnrd")
@export_category("Dialogues")
@export var start_dialogue := preload("uid://b0a3nr7mn8k26")
@export var rock_dialogue := preload("uid://dr7xqekv3npkl")

@export_category("Map Elements")
@export var item_spawner: Marker2D

func _ready():
    #InputHandler.start_cutscene()
    Global.player.get_node("PlayerSprite").animation_override = true
    Global.player.get_node("PlayerSprite").animation = "sleep"

    var dialogue_balloon = ballon.instantiate()
    get_tree().current_scene.add_child(dialogue_balloon)
    dialogue_balloon.start(start_dialogue, "start")

func wakeup():
    Global.player.get_node("PlayerSprite").animation_override = false
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
