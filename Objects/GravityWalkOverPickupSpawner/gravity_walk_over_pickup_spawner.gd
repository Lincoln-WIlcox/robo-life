class_name GravityWalkOverPickupSpawner
extends Node2D

@export var gravity_walk_over_pickup_packed_scene: PackedScene
@export var spawn_amount := 1
@export var spawn_range_width := 10
@export var node_to_spawn_pickup_in: Node

var pickup_collision_excludes: Array[PhysicsBody2D]

func _ready():
	if gravity_walk_over_pickup_packed_scene == null:
		push_error("no scene given for gravity_walk_over_pickup_packed_scene for GravityWalkOverPickupSpawner.")

func spawn():
	var spawns_remaining = spawn_amount
	while spawns_remaining > 0:
		_spawn_one()
		spawns_remaining -= 1

func _spawn_one() -> void:
	var gravity_walk_over_pickup: Node = _create_pickup()
	
	if node_to_spawn_pickup_in == null:
		push_warning("no node for spawning pickups. spawning in self.")
		add_child(gravity_walk_over_pickup)
	else:
		node_to_spawn_pickup_in.add_child(gravity_walk_over_pickup)
	
	gravity_walk_over_pickup.global_position = global_position
	gravity_walk_over_pickup.global_position.x += randf_range(-spawn_range_width/2.0, spawn_range_width/2.0)

func _create_pickup() -> Node:
	var gravity_walk_over_pickup: Node = gravity_walk_over_pickup_packed_scene.instantiate()
	for exception: PhysicsBody2D in pickup_collision_excludes:
		gravity_walk_over_pickup.add_collision_exception_with(exception)
	
	return gravity_walk_over_pickup
