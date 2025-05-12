extends SteeringStrategy

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

const PADDING_DIVISOR = 2
const MAINTAIN_TARGET_DISTANCE = 100

@export var raycast_length: float = 30:
	set(new_value):
		raycast_length = new_value
		if is_node_ready():
			update_raycasts_length()
@export var raycasts_center: Node2D

@onready var query_raycasts_container: Node2D = $QueryRaycasts

func _ready():
	update_raycasts_length()

func _physics_process(delta):
	update_raycasts_pos()

func update_raycasts_length() -> void:
	for raycast: RayCast2D in query_raycasts_container.get_children() as Array[RayCast2D]:
		raycast.target_position = raycast.target_position.normalized() * raycast_length

func update_raycasts_pos() -> void:
	query_raycasts_container.global_position = raycasts_center.global_position

func get_danger_vector() -> Vector2:
	var direction_dangers: Array[float] = _get_dangers()
	
	var normalized_directions_assigner: Array = DIRECTIONS.map(func(d: Vector2) -> Vector2: return d.normalized())
	var normalized_directions: Array[Vector2]
	normalized_directions.assign(normalized_directions_assigner)
	var weighted_average_direction: Vector2 = Utils.vectors_weighted_combination(normalized_directions, direction_dangers)
	
	print("avoid walls vector: ", weighted_average_direction)
	
	return weighted_average_direction

func _get_dangers() -> Array[float]:
	var raycasts_assigner: Array[Node] = query_raycasts_container.get_children()
	var raycasts: Array[RayCast2D]
	raycasts.assign(raycasts_assigner)
	
	var danger_array: Array[float]
	for i: int in range(raycasts.size()):
		if raycasts[i].is_colliding():
			var weight = _get_raycast_danger_weight(raycasts[i])
			
			danger_array.append(weight)
		else:
			var weight = _get_padding_weight(Utils.get_in_array_wrap(raycasts, i - 1), Utils.get_in_array_wrap(raycasts, i + 1))
			danger_array.append(weight)
	
	return danger_array

func _get_raycast_danger_weight(raycast: RayCast2D) -> float:
	if not raycast.is_colliding():
		return 0
	
	var collision_point_distance: float = raycast.global_position.distance_to(raycast.get_collision_point())
	var target_position_distance: float = raycast.target_position.length()
	var collision_distance_percent: float = collision_point_distance / target_position_distance
	return collision_distance_percent

func _get_padding_weight(previous_raycast: RayCast2D, next_raycast: RayCast2D) -> float:
	return (_get_raycast_danger_weight(previous_raycast) + _get_raycast_danger_weight(next_raycast)) / 2 / PADDING_DIVISOR
