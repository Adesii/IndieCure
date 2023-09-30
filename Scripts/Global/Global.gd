extends Node


var current_character : IndieCharacter

var current_scene = null
func _ready():
    var root = get_tree().root
    current_scene = root.get_child(root.get_child_count() - 1)

func load_stage(stage_scene : PackedScene):
    var oldscene = current_scene
    var stage = stage_scene.instantiate()

    current_scene = stage

    
    get_tree().root.add_child(stage)
    #get_tree().current_scene = stage
    
    #add character scene
    current_scene.add_child(current_character.character_scene.instantiate())

    oldscene.queue_free()