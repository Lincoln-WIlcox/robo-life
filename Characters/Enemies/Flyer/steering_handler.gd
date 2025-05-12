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

const TARGET_FACTOR = 4
const DISTANCE_FACTOR = 3
const PADDING_DIVISOR = 2
const MAINTAIN_TARGET_DISTANCE = 100

@export var character: CharacterBody2D
@export var query_raycasts_container: Node2D

var target: Target

func get_preferred_direction_to_target_pos(steering_target: Vector2) -> Vector2:
	var direction_interests: Array[float] = _get_interests(steering_target)
	var direction_dangers: Array[float] = _get_dangers()
	
	var direction_preferences: Array[float] = _get_direction_preferences(direction_interests, direction_dangers)
	
	var weighted_average_direction: Vector2 = Utils.vectors_weighted_combination(DIRECTIONS, direction_preferences)
	
	return weighted_average_direction.normalized()

func _get_dangers() -> Array[float]:
	var raycasts_assigner: Array[Node] = query_raycasts_container.get_children()
	var raycasts: Array[RayCast2D]
	raycasts.assign(raycasts_assigner)
	
	var danger_array: Array[float]
	for i: int in range(raycasts.size()):
		if raycasts[i].is_colliding():
			var weight = _get_danger_weight(raycasts[i], DIRECTIONS[i])
			
			danger_array.append(weight)
		else:
			var weight = _get_padding_weight(Utils.get_in_array_wrap(raycasts, i - 1), Utils.get_in_array_wrap(DIRECTIONS, i - 1), Utils.get_in_array_wrap(raycasts, i + 1), Utils.get_in_array_wrap(DIRECTIONS, i + 1))
			danger_array.append(weight)
	
	return danger_array

func _get_interests(steering_target: Vector2) -> Array[float]:
	var vector_to_steering_target: Vector2 = character.global_position.direction_to(steering_target).normalized()
	
	var interest_vectors_assigner: Array = DIRECTIONS.map(func(dir: Vector2) -> float: return vector_to_steering_target.normalized().dot(dir.normalized()))
	var interest_vectors: Array[float]
	interest_vectors.assign(interest_vectors_assigner)
	
	return interest_vectors

func _get_direction_preferences(direction_interests: Array[float], direction_dangers: Array[float]) -> Array[float]:
	var direction_preferences: Array[float]
	for i: int in range(direction_interests.size()):
		#preference is usually between -1 and 1, thus we add 1 and divide by 2 to make it between 0 and 1
		var preference: float = direction_interests[i] - direction_dangers[i]
		direction_preferences.append(preference)
	return direction_preferences

func _get_danger_weight(raycast: RayCast2D, dir: Vector2) -> float:
	var raycast_weight: float = _get_raycast_danger_weight(raycast)
	var target_weight: float = _get_target_danger_weight_in_dir(dir)
	
	return (raycast_weight + target_weight) / 2

func _get_raycast_danger_weight(raycast: RayCast2D) -> float:
	if not raycast.is_colliding():
		return 0
	
	var collision_point_distance: float = raycast.global_position.distance_to(raycast.get_collision_point())
	var target_position_distance: float = raycast.target_position.length()
	var collision_distance_percent: float = collision_point_distance / target_position_distance
	var weight: float = DISTANCE_FACTOR - (DISTANCE_FACTOR * collision_distance_percent)
	return weight

func _get_target_danger_weight_in_dir(dir: Vector2) -> float:
	var vector_to_target: Vector2 = character.global_position - target.global_position
	
	if vector_to_target.length() > MAINTAIN_TARGET_DISTANCE:
		return 0
	
	var target_dot: float = vector_to_target.normalized().dot(dir.normalized())
	var weight: float = ((target_dot + 1) / 2) * TARGET_FACTOR
	return weight

func _get_padding_weight(previous_raycast: RayCast2D, previous_dir: Vector2, next_raycast: RayCast2D, next_dir: Vector2) -> float:
	return (_get_danger_weight(previous_raycast, previous_dir) + _get_danger_weight(next_raycast, next_dir)) / 2 / PADDING_DIVISOR
