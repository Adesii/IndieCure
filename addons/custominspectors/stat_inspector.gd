extends EditorInspectorPlugin

var stat_editor = preload("res://addons/custominspectors/stat_editor.gd")



func _can_handle(object):
    return true


func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
    if type == TYPE_OBJECT and hint_type == PROPERTY_HINT_RESOURCE_TYPE and hint_string == "StatUpgradeResource":
        var ed = stat_editor.new()
        ed.is_resource = true
        add_property_editor(name,ed)
        return true
    if type == TYPE_OBJECT and hint_type == PROPERTY_HINT_RESOURCE_TYPE and hint_string == "AttributePair":
        add_property_editor(name,stat_editor.new())
        return true
    return false