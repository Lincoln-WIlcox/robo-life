extends State

@export var standing_state: State
@export var falling_state: State
@export var jumping_state: State
@export var character: CharacterBody2D
@export var detect_pushing_component: DetectPushingComponent
@export var push_sticky_left_side: Marker2D
@export var push_sticky_right_side: Marker2D
@export var push_speed := 200

var is_moving_left: Callable
var is_moving_right: Callable
var just_jumped: Callable

var push_vel_x:
	get:
		return push_speed if is_moving_right.call() else -push_speed

func run():
	if just_jumped.call():
		state_ended.emit(jumping_state)
		return
	
	if detect_pushing_component.is_in_pushing_area and (is_moving_left.call() and detect_pushing_component.pushing_area.global_position.x < character.global_position.x or is_moving_right.call() and detect_pushing_component.pushing_area.global_position.x > character.global_position.x):
		detect_pushing_component.pushing_area.push(push_vel_x)
		character.global_position.x = detect_pushing_component.pushing_area.left_side_of_body.global_position.x - push_sticky_right_side.position.x if is_moving_right.call() else detect_pushing_component.pushing_area.right_side_of_body.global_position.x - push_sticky_left_side.position.x
	else:
		if not character.is_on_floor():
			state_ended.emit(falling_state)
		else:
			state_ended.emit(standing_state)
