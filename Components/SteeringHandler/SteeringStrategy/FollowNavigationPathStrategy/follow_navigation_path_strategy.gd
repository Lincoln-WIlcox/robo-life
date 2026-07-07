extends SteeringStrategy

@export var navigation_agent: NavigationAgent2D
@export var steering_node: Node2D

func get_interest_vector() -> Vector2:
	var vector_to_steering_target: Vector2 = steering_node.global_position.direction_to(navigation_agent.get_next_path_position()).normalized()
	
	return vector_to_steering_target
