class_name SteeringStrategy
extends Node

##Used by [SteeringHandler] to determine an optimal direction to go in. 
##The magnitude of vectors returned by [method SteeringHandler.get_interests] or [method SteeringHandler.get_dangers] represents the weight of that direction.

@export var strategy_weight: float = 1
@export var enabled: bool = true

func get_interest_vector() -> Vector2:
	return Vector2.ZERO

func get_danger_vector() -> Vector2:
	return Vector2.ZERO
