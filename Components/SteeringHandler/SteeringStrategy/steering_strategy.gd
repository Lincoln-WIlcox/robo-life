class_name SteeringStrategy
extends Node

##Used by [SteeringHandler] to determine an optimal direction to go in. 
##The magnitude of vectors returned by [method SteeringHandler.get_interests] or [method SteeringHandler.get_dangers] represents the weight of that direction.

@export var strategy_weight: float

func get_interests() -> Array[Vector2]:
	return []

func get_dangers() -> Array[Vector2]:
	return []
