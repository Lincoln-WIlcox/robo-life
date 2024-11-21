extends Node

const MAX_SCALE = 0.9
const MIN_SCALE = 0.1
const SCALE_STEP = 0.05

@export var scrollable_container: Node2D
@export var map_control: Control

func _input(event):
	if event is InputEventMouseMotion and map_control.has_focus() and Input.is_action_pressed("map_pan"):
		scrollable_container.position += event.relative
	elif event.is_action_pressed("map_zoom_in"):
		scrollable_container.scale.x = min(scrollable_container.scale.x + SCALE_STEP, MAX_SCALE)
		scrollable_container.scale.y = scrollable_container.scale.x
	elif event.is_action_pressed("map_zoom_out"):
		scrollable_container.scale.x = max(scrollable_container.scale.x - SCALE_STEP, MIN_SCALE)
		scrollable_container.scale.y = scrollable_container.scale.x
