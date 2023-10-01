extends Node2D


const SPEED = 30.0

var positionkey :int = -1100

@export var character : CharacterBody2D

func _physics_process(delta):

	if Global.player == null:
		return

	var collsiongroupresult = CollisionAvoidance.handle_collisiongroup(character,positionkey)
	if collsiongroupresult.cellfull:
		return
	positionkey = collsiongroupresult.last_position_key

	var direction = (Global.player.position - character.position).normalized()
	character.velocity = direction * SPEED

	var collisionresult = CollisionAvoidance.avoid_others(character,positionkey,32)
	
	character.velocity += collisionresult * SPEED *0.5
	
	#character.set_deferred("position", character.position + velocity * delta)
	#character.position += velocity * delta

	character.move_and_slide()
