extends State

@export var character: CharacterBody2D
@export var falling_state: State
@export var climbing_state: State
@export var velocity_component: VelocityComponent
@export var jumping_speed := -820
@export var horizontal_movement_component: HorizontalMovementComponent

@onready var timer = $JumpingTimer

var is_jumping: Callable
var is_moving_down: Callable

func enter():
	timer.start()

func run():
	horizontal_movement_component.handle_movement()
	
	if is_jumping.call() and !timer.is_stopped():
		velocity_component.velocity.y = jumping_speed
	else:
		state_ended.emit(falling_state)
	
	if character.is_on_ceiling():
		state_ended.emit(falling_state)

func exit():
	timer.stop()

func _on_climbing_rope_detector_climbable_climbed(_climbable_area):
	if is_current_state.call():
		state_ended.emit(climbing_state)
