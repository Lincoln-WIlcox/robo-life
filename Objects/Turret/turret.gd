class_name Turret
extends Node2D

@export var target: Target:
	set(new_value):
		target = new_value
		if is_node_ready():
			update_children_target()
@export var node_to_put_bullets_in: Node:
	set(new_value):
		node_to_put_bullets_in = new_value
		if is_node_ready():
			update_children_node_to_put_bullets_in()

@onready var raycast: RayCast2D = $TurretPivot/RayCast2D
@onready var aggro_range_handler = $AggroRangeHandler
@onready var shooting = $StateMachine/Shooting
@onready var shoot_component: ShootComponent = $ShootComponent

func _ready():
	update_children_target()
	update_children_node_to_put_bullets_in()

func update_children_target() -> void:
	aggro_range_handler.target = target
	shooting.target = target

func update_children_node_to_put_bullets_in() -> void:
	shoot_component.node_to_put_bullets_in = node_to_put_bullets_in

func _physics_process(delta):
	raycast.target_position = target.global_position - raycast.global_position
	raycast.global_rotation = 0

func _on_overheater_max_heat_reached():
	queue_free()
