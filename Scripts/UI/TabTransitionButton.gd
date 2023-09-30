extends Button

@export var tabController : TabController
@export var target : Control

func _on_pressed():
	if tabController:
		tabController.set_current_tab(target)
