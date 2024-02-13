@tool
extends Button


@export var scenetouse : PackedScene

@export var scrollpanel : VBoxContainer


@export var timelinescenetouse : PackedScene
@export var timelinescrollpanel : VBoxContainer


func _ready():
	pressed.connect(on_pressed)

func on_pressed():
	for i in 10:
		var scene = scenetouse.instantiate()
		scrollpanel.add_child(scene)
		var timeline = timelinescenetouse.instantiate()
		timelinescrollpanel.add_child(timeline)