class_name EnvironmentQuerySystem
extends Node

##Used for getting information about the enviornment. Instanced as part of the world and injected into objects that depend on it. Objects will add themselves to the system.


const TILE_COLLISION_LAYER = 0
const TILE_POLYGON_INDEX = 0

enum TILE_POLYGON_RETURN_KEYS
{
	POLYGON,
	TILES
}


@export var initial_tile_map_layers: Array[TileMapLayer]

var _tile_map_layers: Array[TileMapLayer]
var _solid_entity_bodies: Array[PhysicsBody2D]
var _queryable_entities: Array[QueryableEntity]
var _map_entities: Array[MapEntity]

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
	_queryable_entities.append(queryable_entity)

func add_map_entity(map_entity: MapEntity, remove_on_tree_exiting = true) -> void:
	if remove_on_tree_exiting:
		map_entity.tree_exiting.connect(func(): _map_entities.erase(map_entity))
	_map_entities.append(map_entity)

func get_solidity_as_polygons() -> Array[PackedVector2Array]:
	var tile_map_polygons = _get_collision_polygons_for_tile_map_layer(_tile_map_layers[0])
	return []

##Returns polygons representing the solidity of every tile map tracked by the environment query system merged.
func get_tile_maps_solidity() -> Array[PackedVector2Array]:
	var polygons: Array[PackedVector2Array]
	for tile_map_layer: TileMapLayer in _tile_map_layers:
		var tile_map_layer_polygons: Array[PackedVector2Array] = _get_collision_polygons_for_tile_map_layer(tile_map_layer)
		polygons.append_array(tile_map_layer_polygons)
	polygons = Utils.merge_polygons(polygons)
	return polygons

func get_map_data() -> MapData:
	var tile_map_polygons: Array[PackedVector2Array] = get_tile_maps_solidity()
	
	var map_data: MapData = MapData.new(_map_entities, tile_map_polygons)
	return map_data

func _get_collision_polygons_for_tile_map_layer(tile_map_layer: TileMapLayer) -> Array[PackedVector2Array]:
	#tries every tile pos in tile map layer to see if its solid, when it finds a solid one gets all connected solid tiles and 
	
	var solid_tiles: Array[Vector2i] = tile_map_layer.get_used_cells()
	solid_tiles = solid_tiles.filter(
		func(tile_pos): 
			var tile_data: TileData = tile_map_layer.get_cell_tile_data(tile_pos)
			return Utils.tile_data_has_collision(tile_data)
	)
	var polygons: Array[PackedVector2Array]
	
	for tile_pos: Vector2i in solid_tiles:
		var tile_polygon_return: Dictionary = _get_collision_polygon_for_tile(tile_pos, tile_map_layer)
		var new_polygon: PackedVector2Array = tile_polygon_return[TILE_POLYGON_RETURN_KEYS.POLYGON]
		var checked_tiles: Array[Vector2i] = tile_polygon_return[TILE_POLYGON_RETURN_KEYS.TILES]
		
		for checked_tile_pos: Vector2i in checked_tiles:
			solid_tiles.erase(checked_tile_pos)
		
		polygons.append(new_polygon)
	
	return polygons

#gets solid tiles touching given tile recursively, then take the solidity of those tiles and turn them into one polygon
func _get_collision_polygon_for_tile(tile_pos: Vector2i, tile_map_layer: TileMapLayer) -> Dictionary:
	var tiles: Array[Vector2i] = Utils.get_touching_tiles_with_collision(tile_map_layer, tile_pos, TILE_COLLISION_LAYER, [])
	var tiles_collision_polygons: Array[PackedVector2Array] = _get_collision_polygons_from_collision_tiles(tile_map_layer, tiles)
	var full_polygon: PackedVector2Array = Utils.merge_polygons(tiles_collision_polygons)
	return {TILE_POLYGON_RETURN_KEYS.POLYGON: full_polygon, TILE_POLYGON_RETURN_KEYS.TILES: tiles}

#takes a tile map layer and an array of tiles, returns the solidity of each tile as individual polygons
func _get_collision_polygons_from_collision_tiles(tile_map_layer: TileMapLayer, tiles: Array[Vector2i]) -> Array[PackedVector2Array]:
	var tiles_verts: Array[PackedVector2Array]
	
	for tile_pos: Vector2i in tiles:
		var tile_data: TileData = tile_map_layer.get_cell_tile_data(tile_pos)
		var polygon_verts: PackedVector2Array = tile_data.get_collision_polygon_points(TILE_COLLISION_LAYER, TILE_POLYGON_INDEX)
		
		#polygon verts are relative to center of the tile, so i have to add the tile's local pos to get its position local to the tile map layer.
		for i in range(polygon_verts.size()):
			polygon_verts[i] = polygon_verts[i] + Vector2(tile_map_layer.to_global(tile_map_layer.map_to_local(tile_pos)))
		tiles_verts.append(polygon_verts)
	
	return tiles_verts
