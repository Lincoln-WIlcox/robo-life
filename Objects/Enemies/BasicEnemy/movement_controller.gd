extends Node

const SPEED = 80
const MINIMUM_TIME = .5
const MAXIMUM_TIME = 1.5

@onready var timer: Timer = $Timer

@export var velocity_component: VelocityComponent

var _is_moving_right = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity_component.accelerate_x_to_velocity(SPEED if _is_moving_right else -SPEED)

func _on_timer_timeout():
	_is_moving_right = !_is_moving_right
	var value := randf_range(MINIMUM_TIME, MAXIMUM_TIME)
	timer.wait_time = value
