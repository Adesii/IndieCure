extends Node2D


@export var transition_target: Marker2D
@export var transition_camera: PhantomCamera2D
@export var exit_target: Marker2D
@export var exit_camera: PhantomCamera2D


func enter_room(_v = null):
    if transition_target:
        Global.player.global_position = transition_target.global_position
        transition_camera.set_priority(10)
        transition_camera.set_follow_target(Global.player)

func exit_room(_v = null):
    if exit_target:
        Global.player.global_position = exit_target.global_position
        transition_camera.set_priority(0)
        if exit_camera:
            exit_camera.set_priority(10)