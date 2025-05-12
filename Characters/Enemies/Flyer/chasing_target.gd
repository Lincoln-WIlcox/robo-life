extends State

const PLAYER_CAST_ROTATION_SPEED = 0.012
const PLAYER_CAST_COLLIDING_SPEED = 0.08
const AMOUNT_OF_SHOTS = 5

@export var relative_player_ray_cast: RayCast2D
@export var navigation_agent: NavigationAgent2D
@export var velocity_component: VelocityComponent
@export var steering_handler: Node
@export var shooting_handler: Node

var target: Target

@onready var between_barrage_timer: Timer = $BetweenBarrageTimer
@onready var between_shots_timer: Timer = $BetweenShotsTimer

var _shots_remaining = AMOUNT_OF_SHOTS

func enter():
	between_barrage_timer.start()

func run():
	relative_player_ray_cast.global_position = target.global_position
	
	var rotation_speed: float = PLAYER_CAST_ROTATION_SPEED
	if relative_player_ray_cast.is_colliding():
		rotation_speed = PLAYER_CAST_COLLIDING_SPEED
	relative_player_ray_cast.rotation += rotation_speed
	
	if navigation_agent.is_navigation_finished() or not navigation_agent.is_target_reachable():
		return
	
	var target_position: Vector2 = _get_target_position()
	var target_direction: Vector2 = steering_handler.get_preferred_direction_to_target_pos(target_position)
	velocity_component.accelerate_in_direction_at_full_speed(target_direction)

func _get_target_position() -> Vector2:
	if relative_player_ray_cast.is_colliding():
		return relative_player_ray_cast.get_collision_point()
	return relative_player_ray_cast.global_position + relative_player_ray_cast.target_position.rotated(relative_player_ray_cast.rotation)

func _on_between_barrage_timer_timeout():
	between_shots_timer.start()

func _on_between_shots_timer_timeout():
	shooting_handler.shoot_bullet()
	_shots_remaining -= 1
	
	if _shots_remaining == 0:
		between_shots_timer.stop()
		between_barrage_timer.start()
		_shots_remaining = AMOUNT_OF_SHOTS
