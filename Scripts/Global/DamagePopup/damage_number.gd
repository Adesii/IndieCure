extends Node2D

var dmg_duration: float = 1.0

# rough estimate of how long the damage number will be on screen
# fade in: 0.3 hold: 0.9 fade-out: 1.2 seconds
# on a 1.2 second timeline
# rescaled to 1.0 seconds
# fade in: 0.25 hold: 0.75 fade-out: 1.0 seconds
# 

@export var label_container: Node2D = null
@export var label: Label = null

var tween: Tween = null
var movement_tween: Tween = null

func remove():
	DamageNumbers.remove(self)

func set_value(value: int):
	label.text = str(value)

func set_color(color: Color):
	label.modulate.r = color.r
	label.modulate.g = color.g
	label.modulate.b = color.b

func set_duration(duration: float=1.0):
	dmg_duration = duration

func start():
	if tween == null:
		tween = create_tween()
	
	if movement_tween == null:
		movement_tween = create_tween()

	label_container.position = Vector2(0, 0)

	arc_direction = 1 if randf() > 0.5 else - 1
	arc_amount = randf() * 0.5 + 0.5

	movement_tween.tween_method(arc_up, 0.0, 1.0, dmg_duration)
	movement_tween.play()

	label.modulate.a = 0.0
	label_container.scale = Vector2(0, 0)
	tween.tween_property(label, "modulate:a", 1.0, 0.25 * dmg_duration)
	tween.set_trans(Tween.TRANS_CUBIC)

	tween.parallel().tween_property(label_container, "scale", Vector2(1.4, 1.4), 0.1 * dmg_duration)

	tween.tween_interval(0.25 * dmg_duration)

	tween.tween_property(label, "modulate:a", 0.0, 0.3 * dmg_duration)
	tween.parallel().tween_property(label_container, "scale", Vector2(0, 0), 0.4 * dmg_duration)

	tween.play()
	await tween.finished
	await movement_tween.finished

	tween = null
	movement_tween = null

	remove()

var arc_direction: int = 1
var arc_amount = 0.0

func arc_up(delta: float):
	#delta is the delta from 0-1
	# use it to arc a Vector2 up
	
	var arc_value = Vector2()
	arc_value.y = -delta * 0.1
	arc_value.x = (delta * delta) * 0.1 * arc_direction

	label_container.position += arc_value