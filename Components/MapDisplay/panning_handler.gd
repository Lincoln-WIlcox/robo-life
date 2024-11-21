extends Node

const MAX_SCALE = 0.9
const MIN_SCALE = 0.1
const SCALE_STEP = 0.05

@export var scrollable_container: Node2D
@export var map_control: Control
var upper_left_marker: Node2D
var lower_right_marker: Node2D

var map_box_center: Vector2:
	get:
		return map_control.global_position + (map_control.size / 2)

func _input(event):
	if event is InputEventMouseMotion and map_control.has_focus() and Input.is_action_pressed("map_pan"):
		pan_map(event.relative)
	elif event.is_action_pressed("map_zoom_in"):
		scrollable_container.scale.x = min(scrollable_container.scale.x + SCALE_STEP, MAX_SCALE)
		scrollable_container.scale.y = scrollable_container.scale.x
		pan_map(Vector2.ZERO)
	elif event.is_action_pressed("map_zoom_out"):
		scrollable_container.scale.x = max(scrollable_container.scale.x - SCALE_STEP, MIN_SCALE)
		scrollable_container.scale.y = scrollable_container.scale.x
		pan_map(Vector2.ZERO)

func pan_map(amount: Vector2):
	var real_amount: Vector2 = amount
	if upper_left_marker.global_position.x + amount.x > map_box_center.x:
		real_amount.x = 0
		scrollable_container.global_position.x = map_box_center.x  + (scrollable_container.global_position.x - upper_left_marker.global_position.x)
	if upper_left_marker.global_position.y + amount.y > map_box_center.y:
		real_amount.y = 0
		scrollable_container.global_position.y = map_box_center.y + (scrollable_container.global_position.y - upper_left_marker.global_position.y)
	if lower_right_marker.global_position.x + amount.x < map_box_center.x:
		real_amount.x = 0
		scrollable_container.global_position.x = map_box_center.x + (scrollable_container.global_position.x - lower_right_marker.global_position.x)
	if lower_right_marker.global_position.y + amount.y < map_box_center.y:
		real_amount.y = 0
		scrollable_container.global_position.y = map_box_center.y + (scrollable_container.global_position.y - lower_right_marker.global_position.y)
	
	scrollable_container.position += real_amount
