extends Node

@export var scrollable_container: Node2D
@export var map_control: Control

func _input(event):
	if event is InputEventMouseMotion and map_control.has_focus() and Input.is_action_pressed("map_pan"):
		scrollable_container.position += event.relative
