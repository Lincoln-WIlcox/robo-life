extends Node

const FOG_COLOR = Color.BLACK

@export var scrollable_container: Node2D
@export var fog: TileMapLayer

func create_fog(pixel_size: Vector2) -> void:
	var fog_size_in_tiles: Vector2i = Vector2i(ceili(pixel_size.x / fog.tile_set.tile_size.x), ceili(pixel_size.y / fog.tile_set.tile_size.y))
	
	for x: int in fog_size_in_tiles.x:
		for y: int in fog_size_in_tiles.y:
			var coords: Vector2i = Vector2i(x, y)
			fog.set_cell(coords, 0, Vector2i(0,0))

func reveal_fog(tile_position: Vector2i) -> void:
	fog.set_cell(tile_position)
