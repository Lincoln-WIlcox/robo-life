extends State

@export var idle_state: State
@export var sprite: Sprite2D
@export var shoot_component: ShootComponent
@export var target: Node2D
@export var turret: Turret
@export var bullet_spawn_position: Marker2D
@export var turret_pivot: Node2D
@export var rotation_speed: float = 20

@onready var between_shots_timer: Timer = $BetweenShotsTimer

func enter():
	between_shots_timer.start()

func run():
	var to_target_angle: float = turret.global_position.angle_to_point(target.global_position)
	turret_pivot.rotation = rotate_toward(turret_pivot.rotation, to_target_angle, rotation_speed * get_physics_process_delta_time())

func _on_between_shots_timer_timeout():
	if is_current_state.call():
		shoot_component.shoot(target.global_position, bullet_spawn_position.global_position)

func exit():
	between_shots_timer.stop()

func _on_aggro_range_handler_aggro_lost():
	state_ended.emit(idle_state)
