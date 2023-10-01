extends CharacterBody2D


const SPEED = 30.0

var positionkey :int = -1100


func _physics_process(delta):

	if Global.player == null:
		return

	var collsiongroupresult = CollisionAvoidance.handle_collisiongroup(self,positionkey)
	if collsiongroupresult.cellfull:
		return
	positionkey = collsiongroupresult.last_position_key

	var direction = (Global.player.position - position).normalized()
	velocity = direction * SPEED

	var collisionresult = CollisionAvoidance.avoid_others(self,positionkey,32)
	
	velocity += collisionresult * SPEED *0.5
	
	move_and_slide()
