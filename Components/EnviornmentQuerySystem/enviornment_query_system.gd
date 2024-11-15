class_name EnvironmentQuerySystem
extends Node

##Used for getting information about the enviornment. Instanced as part of the world and injected into objects that depend on it. Objects will add themselves to the system.

@export var initial_tile_map_layers: Array[TileMapLayer]

var _tile_map_layers: Array[TileMapLayer]
var _solid_entity_bodies: Array[PhysicsBody2D]
var _queryable_entities: Array[QueryableEntity]

func _ready():
	for tile_map_layer: TileMapLayer in initial_tile_map_layers:
		add_tile_map_layer(tile_map_layer)

##Used to add a tile map layer to the query system.
func add_tile_map_layer(tile_map_layer: TileMapLayer, remove_on_tree_exiting = true) -> void:
	if remove_on_tree_exiting:
		tile_map_layer.tree_exiting.connect(func(): _tile_map_layers.erase(tile_map_layer))
	_tile_map_layers.append(tile_map_layer)

##Used to add a physics body to the query system. 
func add_solid_entity_body(body: PhysicsBody2D, remove_on_tree_exiting = true) -> void:
	if remove_on_tree_exiting:
		body.tree_exiting.connect(func(): _solid_entity_bodies.erase(body))
	_solid_entity_bodies.append(body)

##Used to add a queryable. See [QueryableEntity]
func add_entity_queryable(queryable_entity: QueryableEntity, remove_on_tree_exiting = true) -> void:
	if remove_on_tree_exiting:
		queryable_entity.tree_exiting.connect(func(): _queryable_entities.erase(queryable_entity))
	_queryable_entities.append(QueryableEntity)

##Used to get the shape of the colliders in the surrounding area. A range of size 0 will be infinite.
func get_collision_shapes_as_polygons(position: Vector2, range: Rect2 = Rect2(0,0,0,0)):
	pass
