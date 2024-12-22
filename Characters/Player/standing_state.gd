extends State

const TURN_AROUND_RATE = 30
const DUST_Y_OFFSET = 10

@export var velocity_component: VelocityComponent
@export var jumping_state: State
@export var falling_state: State
@export var climbing_state: State
@export var pushing_state: State
@export var detect_pushing_component: DetectPushingComponent
@export var character: CharacterBody2D
@export var horizontal_movement_component: HorizontalMovementComponent
@export var dust_spawner: DustSpawner
@export var jump_buffer_timer: Timer
@export var standing_horizontal_accel_rate := 100

@onready var coyote_timer = $CoyoteTimer

var just_jumped: Callable
var is_jumping: Callable
var is_moving_down: Callable
var is_moving_left: Callable
var is_moving_right: Callable
var just_climbed: Callable

func enter():
	horizontal_movement_component.accel_rate = standing_horizontal_accel_rate
	
	if !jump_buffer_timer.is_stopped() and is_jumping.call():
		state_ended.emit(jumping_state)

func run():
	horizontal_movement_component.handle_movement()
	
	character.set_collision_mask_value(Utils.CollisionLayers.OneWayPlatforms, true)
	if just_jumped.call():
		if is_moving_down.call():
			character.set_collision_mask_value(Utils.CollisionLayers.OneWayPlatforms, false)
			state_ended.emit(falling_state)
		else:
			dust_spawner.create_dust(Vector2(character.position.x, character.position.y + DUST_Y_OFFSET))
			state_ended.emit(jumping_state)
	elif !character.is_on_floor() and coyote_timer.is_stopped():
		coyote_timer.start()
	elif character.is_on_floor():
		coyote_timer.stop()
	
	if is_moving_left.call() and velocity_component.velocity.x > 0 or is_moving_right.call() and velocity_component.velocity.x < 0:
		velocity_component.decelerate_at_rate(TURN_AROUND_RATE)
	
	if character.is_on_wall() and detect_pushing_component.is_in_pushing_area and (is_moving_left.call() and detect_pushing_component.pushing_area.global_position.x < character.global_position.x or is_moving_right.call()  and detect_pushing_component.pushing_area.global_position.x > character.global_position.x):
		state_ended.emit(pushing_state)

func exit():
	coyote_timer.stop()
	horizontal_movement_component.reset_accel_rate()

func _on_coyote_timer_timeout() -> void:
	if !character.is_on_floor():
		state_ended.emit(falling_state)

func _on_climbing_rope_detector_climbable_climbed(_climbable_area):
	
	if is_current_state.call() and just_climbed.call(): 
		state_ended.emit(climbing_state)
