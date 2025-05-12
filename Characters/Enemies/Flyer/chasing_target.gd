extends State

const PLAYER_CAST_ROTATION_SPEED = 0.012
const PLAYER_CAST_COLLIDING_SPEED = 0.08
const AMOUNT_OF_SHOTS = 5
const MIN_TIME_TO_CHANGE_ROTATION_DIR = 1
const MAX_TIME_TO_CHANGE_ROTATION_DIR = 9

@export var relative_player_ray_cast: RayCast2D
@export var navigation_agent: NavigationAgent2D
@export var velocity_component: VelocityComponent
@export var steering_handler: SteeringHandler
@export var shooting_handler: Node

var target: Target

@onready var between_barrage_timer: Timer = $BetweenBarrageTimer
@onready var between_shots_timer: Timer = $BetweenShotsTimer
@onready var raycast_rotation_change_timer = $RaycastRotationChangeTimer

var _shots_remaining = AMOUNT_OF_SHOTS
var _rotation_dir: float = 1

func enter():
	between_barrage_timer.start()
	raycast_rotation_change_timer.start()

func run():
	relative_player_ray_cast.global_position = target.global_position
	
	var rotation_speed: float = PLAYER_CAST_ROTATION_SPEED
	if relative_player_ray_cast.is_colliding():
		rotation_speed = PLAYER_CAST_COLLIDING_SPEED
	relative_player_ray_cast.rotation += rotation_speed * _rotation_dir
	
	if navigation_agent.is_navigation_finished() or not navigation_agent.is_target_reachable():
		return
	
	var target_velocity: Vector2 = steering_handler.get_preferred_velocity()
	velocity_component.accelerate_to_velocity(target_velocity)

func exit():
	between_barrage_timer.stop()
	raycast_rotation_change_timer.stop()

func _on_between_barrage_timer_timeout():
	between_shots_timer.start()

func _on_between_shots_timer_timeout():
	shooting_handler.shoot_bullet()
	_shots_remaining -= 1
	
	if _shots_remaining == 0:
		between_shots_timer.stop()
		between_barrage_timer.start()
		_shots_remaining = AMOUNT_OF_SHOTS

func _on_raycast_rotation_change_timer_timeout():
	raycast_rotation_change_timer.wait_time = randf_range(MIN_TIME_TO_CHANGE_ROTATION_DIR, MAX_TIME_TO_CHANGE_ROTATION_DIR)
	_rotation_dir = -_rotation_dir
