extends SteeringStrategy

@export var target: Node2D
@export var steering_node: Node2D
@export var min_distance: float = 50
@export var max_distance: float = 100

func get_interest_vector() -> Vector2:
	if steering_node.global_position.distance_to(target.global_position) < max_distance:
		return Vector2.ZERO
	
	var vector_to_steering_target: Vector2 = steering_node.global_position.direction_to(target.global_position).normalized()
	
	return vector_to_steering_target

func get_danger_vector() -> Vector2:
	if steering_node.global_position.distance_to(target.global_position) > min_distance:
		return Vector2.ZERO
	
	var vector_to_steering_target: Vector2 = steering_node.global_position.direction_to(target.global_position).normalized()
	
	return vector_to_steering_target
