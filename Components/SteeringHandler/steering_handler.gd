class_name SteeringHandler
extends Node

func get_preferred_direction() -> Vector2:
	var steering_strategies: Array[SteeringStrategy] = _get_steering_strategies()
	
	var interest_vectors: Array[Vector2] = _get_interest_vectors_from_steering_strategies(steering_strategies)
	var danger_vectors: Array[Vector2]
	
	var preferred_direction: Vector2 = _get_preferred_direction_from_vectors(interest_vectors, danger_vectors)
	
	return preferred_direction

func _get_preferred_direction_from_vectors(interest_vectors: Array[Vector2], danger_vectors: Array[Vector2]) -> Vector2:
	var total_vector: Vector2
	
	for interest_vector: Vector2 in interest_vectors:
		total_vector += interest_vector
	
	for danger_vector: Vector2 in danger_vectors:
		total_vector -= danger_vector
	
	return total_vector

func _get_steering_strategies() -> Array[SteeringStrategy]:
	return get_children().filter(func(node: Node) -> bool: return node is SteeringStrategy)

func _get_interest_vectors_from_steering_strategies(steering_strategies: Array[SteeringStrategy]) -> Array[Vector2]:
	return steering_strategies.map(
		func(sts: SteeringStrategy) -> Array[Vector2]: 
			return sts.get_interests().map(
			func(i: Vector2) -> Vector2:
				return i * sts.strategy_weight
				)
			)

func _get_danger_vectors_from_steering_strategies(steering_strategies: Array[SteeringStrategy]) -> Array[Vector2]:
	return steering_strategies.map(
		func(sts: SteeringStrategy) -> Array[Vector2]: 
			return sts.get_dangers().map(
			func(i: Vector2) -> Vector2:
				return i * sts.strategy_weight
				)
			)
