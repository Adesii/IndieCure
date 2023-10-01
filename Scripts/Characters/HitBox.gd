extends Area2D





func _on_area_entered(area:Area2D):
	print("entered, area: ", area.owner.name)
