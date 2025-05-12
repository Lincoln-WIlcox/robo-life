class_name VelocityComponent
extends Node

##Provides an interface for handling acceleration and velocity for a [CharacterBody2D].

##The [CharacterBody2D] this component is moving.
@export var affecting_node : CharacterBody2D
@export_group("Variables")
##The rate of acceleration.
@export var acceleration_coefficient := 50.0
##If speed is larger than terminal_speed, and [member VelocityComponent.limit_velocity_every_frame] is true, speed will decrease at a rate of [member VelocityComponent.decrease_to_terminal_speed_weight].
@export var terminal_speed := 1200
##The rate at which [member VelocityComponent.velocity] slows while speed is over [member VelocityComponent.terminal_speed] and [member VelocityComponent.limit_velocity_every_frame] is true.
@export var decrease_to_terminal_speed_weight := 0.1
##The speed of [member VelocityComponent.velocity] will not be higher than this value while [member VelocityComponent.limit_velocity_every_frame] is true.
@export var max_speed := 1400
##When true, the speed of [member VelocityComponent.velocity] decreases while over [member VelocityComponent.terminal_speed] and will not go over [member VelocityComponent.max_speed].
@export var limit_velocity_every_frame := true
##When true, will move [member VelocityComponent.affecting_node] every physics frame.
@export var move_node_every_frame := true
##When true, and when [method VelocityComponent.limit_velocity] is called or [member VelocityComponent.limit_velocity_every_frame] is true, 
##[member VelocityComponent.velocity.x] will be set to 0 when [member VelocityComponent.affecting_node] is touching a wall, 
##and [member VelocityComponent.velocity.y] will be set to 0 when [member VelocityComponent.affecting_node] is touching a floor or ceiling.
@export var stop_velocity_when_against_walls := true
@export var use_real_velocity := false

var velocity: Vector2:
	get:
		return affecting_node.velocity
	set(new_value):
		affecting_node.velocity = new_value

var is_moving_down: bool:
	get:
		return velocity.y > 0

var is_moving_up: bool:
	get:
		return velocity.y < 0

var is_moving_left: bool:
	get:
		return velocity.x < 0

var is_moving_right: bool:
	get:
		return velocity.x > 0

var is_still: bool:
	get:
		return velocity == Vector2.ZERO

#Do not set _acceleration (it's marked as private for a reason). Instead, use the methods provided to interact with _acceleration.
var _acceleration := Vector2.ZERO 

func _physics_process(_delta):
	if limit_velocity_every_frame:
		limit_velocity()
	#if add_last_move_y_when_leaving_slope and affecting_node.is_on_wall() and !affecting_node.test_move(affecting_node.transform, velocity * delta):
		#velocity = affecting_node.get_real_velocity()
	if move_node_every_frame:
		move_node()
	
	_acceleration = Vector2.ZERO

func update():
	limit_velocity()
	move_node()
	_acceleration = Vector2.ZERO

##When the speed of [member VelocityComponent.velocity] is over [member VelocityComponent.terminal_speed], this will decrease speed by [member VelocityComponent.decrease_to_terminal_speed_weight]. [br]
##This will also not allow speed to go above [member VelocityComponent.max_speed].
func limit_velocity() -> void:
	velocity = velocity.limit_length(max_speed)
	
	if stop_velocity_when_against_walls:
		if affecting_node.is_on_floor() and velocity.y > 0 or affecting_node.is_on_ceiling() and velocity.y < 0:
			velocity.y = 0
		if (affecting_node.is_on_wall() and int(rad_to_deg(affecting_node.get_wall_normal().angle())) + 90 % 360 >= 0 and int(rad_to_deg(affecting_node.get_wall_normal().angle())) + 90 % 360  < 180 and velocity.x < 0 
		or affecting_node.is_on_wall() and int(rad_to_deg(affecting_node.get_wall_normal().angle())) + 90 % 360  >= 180 and int(rad_to_deg(affecting_node.get_wall_normal().angle())) + 90 % 360  < 360 and velocity.x > 0):
			velocity.x = 0
	
	var next_velocity_length = velocity + _acceleration
	var after_decrease_to_terminal_speed_velocity = velocity.lerp(velocity.limit_length(terminal_speed), decrease_to_terminal_speed_weight)
	
	#if speed is greater than terminal speed and velocity is not decelerating faster than it would after applying the speed decrease to terminal speed, decrease speed towards terminal speed
	if velocity.length() > terminal_speed and next_velocity_length.length() > after_decrease_to_terminal_speed_velocity.length(): 
		velocity = after_decrease_to_terminal_speed_velocity
	
	if velocity.length() < Utils.MINIMUM_SPEED:
		velocity = Vector2.ZERO

##Will move [member VelocityComponent.velocity] towards [param target_velocity] by [member VelocityComponent.acceleration_coefficient]. [br]
##This will only change [member VelocityComponent.velocity] once. To accelerate continuously, call every frame.
func accelerate_to_velocity(target_velocity : Vector2) -> void:
	_acceleration += velocity - target_velocity
	velocity = velocity.lerp(target_velocity, acceleration_coefficient / (target_velocity - velocity).length())

##Like [method VelocityComponent.accelerate_to_velocity], but only for the X axis.
func accelerate_x_to_velocity(target_x: float) -> void:
	var difference = velocity.x - target_x
	_acceleration.x += difference
	var weight = acceleration_coefficient / abs(difference) if difference != 0 else 0
	weight = clamp(weight, 0, 1)
	velocity.x = lerpf(velocity.x, target_x, weight)

##Like [method VelocityComponent.accelerate_to_velocity], but only for the Y axis.
func accelerate_y_to_velocity(target_y: float) -> void:
	var difference = velocity.y - target_y
	_acceleration.y += difference
	var weight = acceleration_coefficient / abs(difference) if difference != 0 else 0
	weight = clamp(weight, 0, 1)
	velocity.y = lerpf(velocity.y, target_y, weight)

##Will move [member VelocityComponent.velocity] towards [param target_velocity] by [param custom_accel_coefficient]. [br]
##This will only change [member VelocityComponent.velocity] once. To accelerate continuously, call every frame.
func accelerate_to_velocity_at_rate(target_velocity : Vector2, custom_accel_coefficient : float) -> void:
	_acceleration += velocity - target_velocity
	var distance_between = velocity - target_velocity
	var distance_between_length = distance_between.length()
	var weight = custom_accel_coefficient / distance_between_length
	weight = clamp(weight, 0, 1)
	velocity = velocity.lerp(target_velocity, weight)

##Like [method VelocityComponent.accelerate_to_velocity_at_rate], but only for the X axis.
func accelerate_x_to_velocity_at_rate(target_x : float, custom_accel_coefficient : float) -> void:
	var difference = velocity.x - target_x
	_acceleration.x += difference
	var weight = custom_accel_coefficient / abs(difference) if difference != 0 else 0
	weight = clamp(weight, 0, 1)
	velocity.x = lerpf(velocity.x, target_x, weight)
 
##Like [method VelocityComponent.accelerate_to_velocity_at_rate], but only for the Y axis.
func accelerate_y_to_velocity_at_rate(target_y : float, custom_accel_coefficient : float) -> void:
	var difference = velocity.y - target_y
	_acceleration.y += velocity.y - target_y
	var weight = custom_accel_coefficient / abs(difference) if difference != 0 else 0
	weight = clamp(weight, 0, 1)
	velocity.y = lerpf(velocity.y, target_y, weight)

##Will move [member VelocityComponent.velocity] in direction [param direction] with target speed of [member VelocityComponent.terminal_speed] by [member VelocityComponent.acceleration_coefficient]. [br]
##This will only change [member VelocityComponent.velocity] once. To accelerate continuously, call every frame.
func accelerate_in_direction_at_full_speed(direction : Vector2) -> void:
	if direction == Vector2.ZERO:
		return
	accelerate_to_velocity(direction.normalized() * terminal_speed)

##Like [method VelocityComponent.accelerate_in_direction_at_full_speed], but only for the X axis. Direction should be positive to accelerate right, and negative to accelerate left.
func accelerate_x_in_direction_at_full_speed(direction : int) -> void:
	if direction == 0:
		return
	accelerate_x_to_velocity(direction / abs(direction) * terminal_speed)

##Like [method VelocityComponent.accelerate_in_direction_at_full_speed], but only for the Y axis. Direction should be positive to accelerate down, and negative to accelerate up.
func accelerate_y_in_direction_at_full_speed(direction : int) -> void:
	if direction == 0:
		return
	accelerate_y_to_velocity(direction / abs(direction) * terminal_speed)

##Will move [member VelocityComponent.velocity] in direction [param direction] with target speed of [member VelocityComponent.terminal_speed] by [param custom_accel_coefficient]. [br]
##This will only change [member VelocityComponent.velocity] once. To accelerate continuously, call every frame.
func accelerate_in_direction_at_full_speed_at_rate(direction : Vector2, custom_accel_coefficient : float) -> void:
	if direction == Vector2.ZERO:
		return
	accelerate_to_velocity_at_rate(direction.normalized() * terminal_speed, custom_accel_coefficient)

##Like [method VelocityComponent.accelerate_in_direction_at_full_speed_at_rate], but only for the X axis. Direction should be positive to accelerate right, and negative to accelerate left.
func accelerate_x_in_direction_at_full_speed_at_rate(direction : int, custom_accel_coefficient : float) -> void:
	if direction == 0:
		return
	accelerate_x_to_velocity_at_rate(direction / abs(direction) * terminal_speed, custom_accel_coefficient)

##Like [method VelocityComponent.accelerate_in_direction_at_full_speed_at_rate], but only for the Y axis. Direction should be positive to accelerate down, and negative to accelerate up.
func accelerate_y_in_direction_at_full_speed_at_rate(direction : int, custom_accel_coefficient : float) -> void:
	if direction == 0:
		return
	accelerate_y_to_velocity_at_rate(direction / abs(direction) * terminal_speed, custom_accel_coefficient)

##Will move [member VelocityComponent.velocity] towards 0 by [member VelocityComponent.acceleration_coefficient]. [br]
##This will only change [member VelocityComponent.velocity] once. To accelerate continuously, call every frame.
func decelerate() -> void:
	accelerate_to_velocity(Vector2.ZERO)

##Like [method VelocityComponent.decelerate], but only for the X axis.
func decelerate_x() -> void:
	accelerate_x_to_velocity(0)

##Like [method VelocityComponent.decelerate], but only for the Y axis.
func decelerate_y() -> void:
	accelerate_y_to_velocity(0)

##Will move [member VelocityComponent.velocity] towards 0 by [param custom_accel_coefficient]. [br]
##This will only change [member VelocityComponent.velocity] once. To accelerate continuously, call every frame.
func decelerate_at_rate(custom_accel_coefficient : float) -> void:
	accelerate_to_velocity_at_rate(Vector2.ZERO, custom_accel_coefficient)

##Like [method VelocityComponent.decelerate_at_rate], but only for the X axis.
func decelerate_x_at_rate(custom_accel_coefficient : float) -> void:
	accelerate_x_to_velocity_at_rate(0, custom_accel_coefficient)

##Like [method VelocityComponent.decelerate_at_rate], but only for the Y axis.
func decelerate_y_at_rate(custom_accel_coefficient : float) -> void:
	accelerate_y_to_velocity_at_rate(0, custom_accel_coefficient)

##Will move [member VelocityComponent.affecting_node] by [member VelocityComponent.velocity]
func move_node() -> void:
	affecting_node.move_and_slide()
	
	if use_real_velocity:
		velocity = affecting_node.get_real_velocity()
