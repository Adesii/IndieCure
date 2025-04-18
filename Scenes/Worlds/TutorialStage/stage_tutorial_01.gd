extends Node2D

@export var ballon := preload("uid://dsfs8yseoxnrd")
@export var start_dialogue := preload("uid://b0a3nr7mn8k26")

func _ready():
    InputHandler.start_cutscene()
    Global.player.get_node("PlayerSprite").animation_override = true
    Global.player.get_node("PlayerSprite").animation = "sleep"

    var dialogue_balloon = ballon.instantiate()
    get_tree().current_scene.add_child(dialogue_balloon)
    dialogue_balloon.start(start_dialogue, "start")

func wakeup():
    Global.player.get_node("PlayerSprite").animation_override = false
    InputHandler.start_gameplay()