class_name FlyerEnemy
extends Node2D

@export var target: Target:
	set(new_value):
		target = new_value
		if is_node_ready():
			_update_children_target()
@export var node_to_put_bullets_in: Node:
	set(new_value):
		node_to_put_bullets_in = new_value
		if is_node_ready():
			_update_children_node_to_spawn()

@onready var navigation_agent: NavigationAgent2D = $CharacterBody2D/NavigationAgent2D
@onready var character_body: CharacterBody2D = $CharacterBody2D
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var reroute_timer: Timer = $RerouteTimer
@onready var relative_player_ray_cast = $RelativePlayerRayCast
@onready var waiting_for_target = $StateMachine/WaitingForTarget
@onready var chasing_target = $StateMachine/ChasingTarget
@onready var shooting_handler = $ShootingHandler
@onready var overheater = $CharacterBody2D/Overheater
@onready var gravity_walk_over_pickup_spawner = $CharacterBody2D/GravityWalkOverPickupSpawner
@onready var maintain_distance_steering_strategy = $SteeringHandler/MaintainDistanceSteeringStrategy

func _ready():
	_movement_setup.call_deferred()
	_update_children_target()
	_update_children_node_to_spawn()
	
	var relative_player_raycast_init_rotation: float = randf_range(0, TAU)
	relative_player_ray_cast.rotation = relative_player_raycast_init_rotation

func update_movement_target():
	navigation_agent.target_position = _get_target_position()

func _movement_setup() -> void:
	#wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	
	update_movement_target()

func _update_children_target() -> void:
	maintain_distance_steering_strategy.target = target
	waiting_for_target.target = target
	chasing_target.target = target
	shooting_handler.target = target

func _update_children_node_to_spawn() -> void:
	shooting_handler.node_to_put_bullets_in = node_to_put_bullets_in
	gravity_walk_over_pickup_spawner.node_to_spawn_pickup_in = node_to_put_bullets_in

func _on_reroute_timer_timeout():
	update_movement_target()

func _on_navigation_agent_2d_navigation_finished():
	update_movement_target()
	reroute_timer.start()

func _on_overheater_max_heat_reached():
	gravity_walk_over_pickup_spawner.spawn()
	queue_free()

func _get_target_position() -> Vector2:
	if relative_player_ray_cast.is_colliding():
		return relative_player_ray_cast.get_collision_point()
	return relative_player_ray_cast.global_position + relative_player_ray_cast.target_position.rotated(relative_player_ray_cast.rotation)
