extends State

const SWITCH_TO_FALLING_RATE = 10
const SLOW_FALL_DECEL_RATE = 5
const FALLING_THRESHOLD = 150
const FAST_FALL_THRESHOLD = 0
const TRANSITION_TO_FAST_FALL_RATE = 80
const FAST_FALL_RATE = 15
const FRAMES_TO_ENABLE_MASK = 10

@export var standing_state: State
@export var ledge_grabbing_state: State
@export var climbing_state: State
@export var character: CharacterBody2D
@export var velocity_component: VelocityComponent
@export var jump_buffer_timer: Timer
@export var horizontal_movement_component: HorizontalMovementComponent

var just_jumped: Callable
var is_jumping: Callable
var is_moving_down: Callable
var _frames_since_started_falling = 0

func enter():
	_frames_since_started_falling = 0

func run():
	horizontal_movement_component.handle_movement()
	
	_frames_since_started_falling += 1
	
	if _frames_since_started_falling > FRAMES_TO_ENABLE_MASK:
		character.set_collision_mask_value(Utils.CollisionLayers.OneWayPlatforms, true)
	
	if velocity_component.velocity.y < FALLING_THRESHOLD:
		velocity_component.accelerate_y_in_direction_at_full_speed_at_rate(1, SWITCH_TO_FALLING_RATE)
	
	elif is_jumping.call():
		velocity_component.decelerate_y_at_rate(SLOW_FALL_DECEL_RATE)
	
	if is_moving_down.call():
		velocity_component.accelerate_y_in_direction_at_full_speed_at_rate(1, FAST_FALL_RATE)
		if velocity_component.velocity.y < FAST_FALL_THRESHOLD:
			velocity_component.accelerate_y_in_direction_at_full_speed_at_rate(1, TRANSITION_TO_FAST_FALL_RATE)
	
	if character.is_on_floor():
		state_ended.emit(standing_state)
	
	if just_jumped.call():
		jump_buffer_timer.start()

func _on_player_ledge_grab_detector_ledge_grabbed(is_left_side: bool) -> void:
	if is_current_state.call() and (is_left_side != horizontal_movement_component.facing_left):
		state_ended.emit(ledge_grabbing_state)

func _on_climbing_rope_detector_climbable_climbed(_climbable_area=):
	if is_current_state.call():
		state_ended.emit(climbing_state)
