extends Node

const SPEED = 80
const MINIMUM_TIME = .5
const MAXIMUM_TIME = 1.5

@onready var timer: Timer = $Timer

@export var velocity_component: VelocityComponent
@export var floor_checker_left: RayCast2D
@export var floor_checker_right: RayCast2D
@export var wall_checker_left: RayCast2D
@export var wall_checker_right: RayCast2D

var _is_moving_right = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity_component.accelerate_x_to_velocity(SPEED if _is_moving_right else -SPEED)
	
	if not floor_checker_left.is_colliding():
		_is_moving_right = true
		_randomize_timer()
	elif not floor_checker_right.is_colliding():
		_is_moving_right = false
		_randomize_timer()
	if wall_checker_left.is_colliding():
		_is_moving_right = true
		_randomize_timer()
	elif wall_checker_right.is_colliding():
		_is_moving_right = false
		_randomize_timer()

func _on_timer_timeout():
	_is_moving_right = !_is_moving_right
	_randomize_timer()

func _randomize_timer():
	var value := randf_range(MINIMUM_TIME, MAXIMUM_TIME)
	timer.wait_time = value
	timer.start()
