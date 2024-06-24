class_name Ledge
extends Area2D

##Used by the player to grab onto.

##The side of the platform this ledge is on.
@export var grab_direction: Utils.GrabDirections

var is_left_side:
	get:
		return grab_direction == Utils.GrabDirections.LEFT
var is_right_side:
	get:
		return grab_direction == Utils.GrabDirections.RIGHT
