@tool
extends EditorPlugin

var plugins: Array = []

func _enter_tree():
	plugins.append(preload("res://addons/custominspectors/stat_inspector.gd").new())



	for plugin in plugins:
		add_inspector_plugin(plugin)
	
	


func _exit_tree():
	for plugin in plugins:
		remove_inspector_plugin(plugin)
	
	plugins.clear()
