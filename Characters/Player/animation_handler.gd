extends Node

@export var jumping_state: State
@export var falling_state: State
@export var animated_sprite: AnimatedSprite2D

var is_moving_left: Callable
var is_moving_right: Callable

func _process(_delta):
	if jumping_state.is_current_state.call():
		animated_sprite.play("Jumping")
	elif falling_state.is_current_state.call():
		animated_sprite.play("Falling")
	elif is_moving_left.call() == is_moving_right.call():
		animated_sprite.play("Idle")
	else:
		animated_sprite.play("Walk")
	
	if is_moving_left.call():
		animated_sprite.flip_h = true
	elif is_moving_right.call():
		animated_sprite.flip_h = false
