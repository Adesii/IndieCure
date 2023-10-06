class_name Enemy
extends RefCounted

var shape_id : RID
var canvas_id : RID
var shadow_canvas_id : RID
var velocity : Vector2
var positionkey :int

var flip_h : bool
var lastfliptime : float

var current_position : Vector2
var global_position : Vector2
var animation_lifetime : float = 0.0
var animation_offset : float = 0.0
var image_offset : int = 0
var layer : String = "front"
var speed : float = 0.0

var health : Attribute = Attribute.new(100,shape_id,"health")

func _to_string():
    return "Enemy: " + str(current_position)+" Health:"+str(health.current_value) + " " + str(velocity) + " " + str(animation_lifetime) + " " + str(image_offset) + " " + str(layer) + " " + str(speed)