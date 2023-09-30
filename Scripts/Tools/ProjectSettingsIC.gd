@tool
extends Node

func _init() -> void:

    #add Character path project settings
    add_custom_project_setting("indiecure/CharacterPaths", "res://Characters", TYPE_STRING, PROPERTY_HINT_DIR, "dir")


func add_custom_project_setting(settingname: String, default_value, type: int, hint: int = PROPERTY_HINT_NONE, hint_string: String = "") -> void:
    if ProjectSettings.has_setting(name): return
	
    var setting_info: Dictionary = {
        "name": settingname, 
        "type": type, 
        "hint": hint, 
        "hint_string": hint_string
    }
    
    ProjectSettings.set_setting(settingname, default_value)
    ProjectSettings.add_property_info(setting_info)
    ProjectSettings.set_initial_value(settingname, default_value)
    ProjectSettings.set_as_basic(settingname, true)