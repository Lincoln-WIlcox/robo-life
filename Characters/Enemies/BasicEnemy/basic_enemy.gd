extends Node2D

@onready var shoot_player_controller = $ShootPlayerController
@onready var pickup_spawner = $GravityWalkOverPickupSpawner

@export var target: Node2D
@export var node_to_put_nodes_in: Node:
	set(new_value):
		node_to_put_nodes_in = new_value
		if is_node_ready():
			shoot_player_controller.node_to_put_bullets_in = node_to_put_nodes_in
			pickup_spawner.node_to_spawn_pickup_in = node_to_put_nodes_in

func _ready():
	shoot_player_controller.node_to_put_bullets_in = node_to_put_nodes_in
	pickup_spawner.node_to_spawn_pickup_in = node_to_put_nodes_in

func _physics_process(delta):
	shoot_player_controller.target = target.global_position

func _on_overheater_max_heat_reached():
	pickup_spawner.spawn()
	queue_free()
