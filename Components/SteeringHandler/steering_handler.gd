class_name SteeringHandler
extends Node

func get_preferred_velocity() -> Vector2:
	var steering_strategies: Array[SteeringStrategy] = _get_steering_strategies()
	
	var interest_vectors: Array[Vector2] = _get_interest_vectors_from_steering_strategies(steering_strategies)
	var danger_vectors: Array[Vector2] = _get_danger_vectors_from_steering_strategies(steering_strategies)
	
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
	var steering_strategies_assigner: Array[Node] = get_children().filter(func(node: Node) -> bool: return node is SteeringStrategy)
	var steering_strategies: Array[SteeringStrategy]
	steering_strategies.assign(steering_strategies_assigner)
	steering_strategies = steering_strategies.filter(func(sts: SteeringStrategy) -> bool: return sts.enabled)
	return steering_strategies

func _get_interest_vectors_from_steering_strategies(steering_strategies: Array[SteeringStrategy]) -> Array[Vector2]:
	var steering_vectors_assigner: Array = steering_strategies.map(
		func(sts: SteeringStrategy) -> Vector2: 
			return sts.get_interest_vector() * sts.strategy_weight
			)
	var steering_vectors: Array[Vector2]
	steering_vectors.assign(steering_vectors_assigner)
	return steering_vectors

func _get_danger_vectors_from_steering_strategies(steering_strategies: Array[SteeringStrategy]) -> Array[Vector2]:
	var steering_vectors_assigner: Array = steering_strategies.map(
		func(sts: SteeringStrategy) -> Vector2: 
			return sts.get_danger_vector() * sts.strategy_weight
			)
	var steering_vectors: Array[Vector2]
	steering_vectors.assign(steering_vectors_assigner)
	return steering_vectors
