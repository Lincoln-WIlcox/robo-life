class_name Door
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal opened
signal closed

func open():
	animation_player.play("SlideDoorUp")
	opened.emit()

func close():
	animation_player.play("SlideDoorDown")
	closed.emit()
