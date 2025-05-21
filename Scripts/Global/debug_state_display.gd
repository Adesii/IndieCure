extends RichTextLabel
func _physics_process(delta):
    if State:
        if State.current_state:
            text = "Current State: " + str(State.current_state)
        else:
            text = "No current state"
    else:
        text = "State not initialized"