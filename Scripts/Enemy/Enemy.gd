class_name Enemy
extends MassObject

var velocity : Vector2
var avoidancevelocity : Vector2
var positionkey :int

var flip_h : bool
var lastfliptime : float

var animation_lifetime : float = 0.0
var animation_offset : float = 0.0
var image_offset_animation : int = 0
var layer : String = "front"
var speed : float = 0.0

var health : Attribute = Attribute.new(100,physics_rid,"health")
