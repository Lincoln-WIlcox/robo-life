class_name GravityWalkOverPickupSpawner
extends Node2D

@export var gravity_walk_over_pickup_packed_scene: PackedScene
@export var spawn_range_width := 10
@export var node_to_spawn_pickup_in: Node

func spawn():
	var gravity_walk_over_pickup = gravity_walk_over_pickup_packed_scene.instantiate()
	node_to_spawn_pickup_in.add_child(gravity_walk_over_pickup)
	gravity_walk_over_pickup.global_position = global_position
	gravity_walk_over_pickup.global_position.x += randi_range(-spawn_range_width/2, spawn_range_width/2)