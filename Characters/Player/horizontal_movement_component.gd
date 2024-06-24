class_name HorizontalMovementComponent
extends Node

@export var velocity_component: VelocityComponent
@export var movement_speed := 1000
@export var default_accel_rate := 200
@export var active := true

var accel_rate = default_accel_rate
var is_moving_left: Callable
var is_moving_right: Callable
var facing_left = false

func _physics_process(delta):
	if active:
		handle_movement()

func handle_movement() -> void:
	var target_velocity_x := 0
	if is_moving_left.call() and velocity_component.velocity.x >= -movement_speed:
		target_velocity_x -= movement_speed
		facing_left = true
	if is_moving_right.call() and velocity_component.velocity.x <= movement_speed:
		target_velocity_x += movement_speed
		facing_left = false
	velocity_component.accelerate_x_to_velocity_at_rate(target_velocity_x, accel_rate)
	
	if not is_moving_left.call() and not is_moving_right.call():
		velocity_component.decelerate_x_at_rate(accel_rate)

func reset_accel_rate():
	accel_rate = default_accel_rate
