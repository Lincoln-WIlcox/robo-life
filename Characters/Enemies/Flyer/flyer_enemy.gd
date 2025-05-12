class_name FlyerEnemy
extends Node2D

@export var target: Target

@onready var navigation_agent: NavigationAgent2D = $CharacterBody2D/NavigationAgent2D
@onready var character_body: CharacterBody2D = $CharacterBody2D
@onready var query_raycasts: Node2D = $CharacterBody2D/QueryRaycasts
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var steering_handler = $SteeringHandler

func _ready():
	_movement_setup.call_deferred()

func _movement_setup() -> void:
	#wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	
	set_movement_target(target.global_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished() or not navigation_agent.is_target_reachable():
		return
	
	var target_direction: Vector2 = steering_handler.get_preferred_direction()
	velocity_component.accelerate_in_direction_at_full_speed(target_direction)
