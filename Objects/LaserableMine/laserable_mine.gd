class_name LaserableMine
extends Node2D

@onready var steel_spawner: GravityWalkOverPickupSpawner = $StaticBody2D/SteelSpawner
@onready var body: StaticBody2D = $StaticBody2D

@export var node_to_put_steel_in: Node

func _ready():
	steel_spawner.node_to_spawn_pickup_in = node_to_put_steel_in
	steel_spawner.pickup_collision_excludes.append(body)
