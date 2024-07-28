class_name Utils
extends Object

const MINIMUM_SPEED = 0.2
const TIME_PASSED_AT_NIGHT = 50
const HIGHEST_LADDER_OFFSET = 5
const ITEM_GRID_TILE_SIZE = 48

enum GrabDirections
{
	LEFT = 1,
	RIGHT
}

enum CollisionLayers
{
	Ground = 1,
	OneWayPlatforms,
	Entities
}

static func make_array_unique(array: Array) -> Array:
	var unique: Array = []
	
	for item in array:
		if not unique.has(item):
			unique.append(item)
	
	return unique

static func get_placing_tile(move_tile: MoveTileArea):
	var item_grid_tile_areas: Array[Area2D] = move_tile.get_overlapping_areas().filter(func(a: Area2D): return a is ItemGridTileArea)
	
	var first_tile = null
	for tile_area: ItemGridTileArea in item_grid_tile_areas:
		if first_tile != null and tile_area.item_grid_tile is ItemGridEmptyTile:
			first_tile = tile_area.item_grid_tile if tile_area.item_grid_tile.global_position.distance_to(move_tile.global_position) < first_tile.global_position.distance_to(move_tile.global_position) else first_tile
		elif tile_area.item_grid_tile is ItemGridEmptyTile:
				first_tile = tile_area.item_grid_tile
	
	return first_tile
