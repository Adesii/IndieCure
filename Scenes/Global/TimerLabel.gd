extends RichTextLabel

func _ready():
	#var stage_node = get_tree().get_root().get_node("StageOne")		# Not elegant, but dont have other idea how to connect to this node? Advice much appreciated
	if Global.is_in_game():
		Global.current_scene.UpdateTimerLabel.connect(_on_timer_label_changed)

func _on_timer_label_changed(new_label):
	self.set_text(new_label)
