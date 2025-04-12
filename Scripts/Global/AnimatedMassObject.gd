extends MassObject

class_name AnimatedMassObject

var sprite_frames: SpriteFrames

var is_animated: bool = false
var animation_name: String = "default"
var animation_lifetime: float = 0.0
var animation_offset: float = 0.0
var image_offset_animation: int = 0


var flip_h: bool
var lastfliptime: float