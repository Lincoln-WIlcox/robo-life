class_name PushArea
extends Area2D

@export var character: CharacterBody2D
@export var left_side_of_body: Marker2D
@export var right_side_of_body: Marker2D

func push(x_velocity: int):
	character.velocity.x = x_velocity
	character.move_and_slide()
	character.velocity.x = 0
