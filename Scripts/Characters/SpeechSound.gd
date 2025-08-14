extends Resource
class_name CharacterSpeechSound

@export var pitch_base := 1.2
@export var pitch_variance := 0.13
@export var base_sound: AudioStream = preload("uid://gdhw7h3m7ii3")

@export var time_between_sound_ms := 100