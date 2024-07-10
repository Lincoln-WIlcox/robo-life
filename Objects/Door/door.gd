class_name Door
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal opened

func open():
	animation_player.play("SlideDoorUp")
	opened.emit()
