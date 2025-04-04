extends Control

signal close


func close_panel():
	close.emit(self)

func get_tighble():
	Global.player.inventory.insert(load("uid://d0j2y528e240y")) # tighble
	close_panel()
