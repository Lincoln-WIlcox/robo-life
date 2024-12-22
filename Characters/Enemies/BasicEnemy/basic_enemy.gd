extends Node2D

@onready var shoot_player_controller = $ShootPlayerController
@onready var pickup_spawner = $CharacterBody2D/GravityWalkOverPickupSpawner
@onready var map_texture_updater = $MapTextureUpdater
@onready var body = $CharacterBody2D

@export var map_entity: MapTexture
@export var target: Target
@export var node_to_put_nodes_in: Node:
	set(new_value):
		node_to_put_nodes_in = new_value
		if is_node_ready():
			shoot_player_controller.node_to_put_bullets_in = node_to_put_nodes_in
			pickup_spawner.node_to_spawn_pickup_in = node_to_put_nodes_in
@export var level_map_entity_collection: MapEntityCollection

func _ready():
	map_entity.get_position = func(): return body.global_position
	map_entity.source_node = self
	map_texture_updater.map_texture = map_entity
	if level_map_entity_collection:
		level_map_entity_collection.add_map_entity(map_entity)
	else:
		push_warning("missing level map MapEntityInjector")
	shoot_player_controller.node_to_put_bullets_in = node_to_put_nodes_in
	pickup_spawner.node_to_spawn_pickup_in = node_to_put_nodes_in

func _physics_process(_delta):
	shoot_player_controller.target = target.global_position

func _on_overheater_max_heat_reached():
	pickup_spawner.spawn()
	queue_free()
