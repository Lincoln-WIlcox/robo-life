class_name FlyerEnemy
extends Node2D

@export var target: Target:
	set(new_value):
		target = new_value
		if is_node_ready():
			steering_handler.target = target

@onready var navigation_agent: NavigationAgent2D = $CharacterBody2D/NavigationAgent2D
@onready var character_body: CharacterBody2D = $CharacterBody2D
@onready var query_raycasts: Node2D = $CharacterBody2D/QueryRaycasts
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var steering_handler = $SteeringHandler

func _ready():
	_movement_setup.call_deferred()
	steering_handler.target = target

func _movement_setup() -> void:
	#wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	
	update_movement_target()

func update_movement_target():
	navigation_agent.target_position = target.global_position

func _physics_process(delta):
	if navigation_agent.is_navigation_finished() or not navigation_agent.is_target_reachable():
		return
	
	var target_direction: Vector2 = steering_handler.get_preferred_direction()
	velocity_component.accelerate_in_direction_at_full_speed(target_direction)

func _on_reroute_timer_timeout():
	update_movement_target()
