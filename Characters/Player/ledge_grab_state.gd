extends State

@export var standing_state: State
@export var jumping_state: State
@export var player_ledge_grab_detector: PlayerLedgeGrabDetector
@export var velocity_component: VelocityComponent
@export var character: CharacterBody2D
@export var grab_left_marker: Marker2D
@export var grab_right_marker: Marker2D
@export var horizontal_jump_vel_x := 580

var ledge: Ledge
var is_moving_left: Callable
var is_moving_right: Callable
var is_moving_down: Callable
var just_jumped: Callable

func enter():
	ledge = player_ledge_grab_detector.ledge
	velocity_component.move_node_every_frame = false
	character.global_position = ledge.global_position - grab_right_marker.position if ledge.is_left_side else ledge.global_position - grab_left_marker.position

func run():
	character.global_position = ledge.global_position - grab_right_marker.position if ledge.is_left_side else ledge.global_position - grab_left_marker.position
	
	if is_moving_left.call() and just_jumped.call():
		velocity_component.velocity = Vector2(-horizontal_jump_vel_x, 0)
		state_ended.emit(jumping_state)
	elif is_moving_right.call() and just_jumped.call():
		velocity_component.velocity = Vector2(horizontal_jump_vel_x, 0)
		state_ended.emit(jumping_state)
	elif just_jumped.call():
		velocity_component.velocity = Vector2.ZERO
		state_ended.emit(jumping_state)
	elif is_moving_down.call():
		velocity_component.velocity = Vector2.ZERO
		state_ended.emit(standing_state)

func exit():
	velocity_component.move_node_every_frame = true
