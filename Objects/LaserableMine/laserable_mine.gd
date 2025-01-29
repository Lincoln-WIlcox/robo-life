class_name LaserableMine
extends Node2D

@onready var steel_spawner: GravityWalkOverPickupSpawner = $StaticBody2D/SteelSpawner
@onready var spawning_handler = $SpawingHandler
@onready var body: StaticBody2D = $StaticBody2D

@export var capacity := 6
@export var node_to_put_steel_in: Node

func _ready():
	spawning_handler.amount_to_spawn = capacity
	steel_spawner.node_to_spawn_pickup_in = node_to_put_steel_in
	steel_spawner.pickup_collision_excludes.append(body)

func _on_spawing_handler_out_of_steel():
	queue_free()
