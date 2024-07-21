class_name Utils
extends Object

const MINIMUM_SPEED = 0.2
const TIME_PASSED_AT_NIGHT = 50
const HIGHEST_LADDER_OFFSET = 5
const ITEM_GRID_TILE_SIZE = 64

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
