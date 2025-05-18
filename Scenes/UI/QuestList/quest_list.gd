extends Control

signal close

func _ready():
    await get_tree().create_timer(3).timeout
    close.emit(self)
    print("Closing quest list")