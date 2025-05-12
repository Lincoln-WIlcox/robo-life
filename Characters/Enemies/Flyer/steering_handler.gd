extends Node

const DIRECTIONS: Array[Vector2] = [
	Vector2(0, -1),
	Vector2(1, -1),
	Vector2(1, 0),
	Vector2(1, 1),
	Vector2(0, 1),
	Vector2(-1, 1),
	Vector2(-1, 0),
	Vector2(-1, -1),
	]

const DISTANCE_FACTOR = 5
const PADDING_DIVISOR = 2

@export var character: CharacterBody2D
@export var query_raycasts_container: Node2D
@export var navigation_agent: NavigationAgent2D

func get_preferred_direction() -> Vector2:
	var direction_interests: Array[float] = _get_interests()
	var direction_dangers: Array[float] = _get_dangers()
	
	var direction_preferences: Array[float] = _get_direction_preferences(direction_interests, direction_dangers)
	
	var preferred_direction_index: int = 0
	
	for i: int in range(direction_preferences.size()):
		if direction_preferences[i] > direction_preferences[preferred_direction_index]:
			preferred_direction_index = i
	
	return DIRECTIONS[preferred_direction_index].normalized()

func _get_dangers() -> Array[float]:
	var raycasts_assigner: Array[Node] = query_raycasts_container.get_children()
	var raycasts: Array[RayCast2D]
	raycasts.assign(raycasts_assigner)
	
	var danger_array: Array[float]
	for i: int in range(raycasts.size()):
		if raycasts[i].is_colliding():
			var weight = _get_danger_weight(raycasts[i])
			danger_array.append(weight)
		else:
			var weight = _get_padding_weight(Utils.get_in_array_wrap(raycasts, i - 1), Utils.get_in_array_wrap(raycasts, i + 1))
			danger_array.append(weight)
	
	return danger_array

func _get_interests() -> Array[float]:
	var vector_to_target: Vector2 = character.global_position.direction_to(navigation_agent.get_next_path_position()).normalized()
	
	var interest_vectors_assigner: Array = DIRECTIONS.map(func(dir: Vector2) -> float: return vector_to_target.normalized().dot(dir))
	var interest_vectors: Array[float]
	interest_vectors.assign(interest_vectors_assigner)
	
	return interest_vectors

func _get_direction_preferences(direction_interests: Array[float], direction_dangers: Array[float]) -> Array[float]:
	var direction_preferences: Array[float]
	for i: int in range(direction_interests.size()):
		direction_preferences.append(direction_interests[i] - direction_dangers[i])
	return direction_preferences

func _get_danger_weight(raycast: RayCast2D) -> float:
	if not raycast.is_colliding():
		return 0
	
	var collision_point_distance: float = raycast.global_position.distance_to(raycast.get_collision_point())
	var target_position_distance: float = raycast.target_position.length()
	var collision_distance_percent: float = collision_point_distance / target_position_distance
	var weight: float = DISTANCE_FACTOR - (DISTANCE_FACTOR * collision_distance_percent)
	return weight

func _get_padding_weight(previous_raycast: RayCast2D, next_raycast: RayCast2D) -> float:
	return (_get_danger_weight(previous_raycast) + _get_danger_weight(next_raycast)) / 2 / PADDING_DIVISOR
