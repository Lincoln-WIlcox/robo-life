extends Node

const FOG_COLOR = Color.BLACK

@export var scrollable_container: Node2D
@export var fog: TileMapLayer

func create_fog(bounding_box: Rect2) -> void:
	var fog_size_in_tiles: Vector2i = Vector2i(ceili(bounding_box.size.x / fog.tile_set.tile_size.x), ceili(bounding_box.size.y / fog.tile_set.tile_size.y))
	var fog_tile_offset: Vector2i = Vector2i(floori(bounding_box.position.x / fog.tile_set.tile_size.x), floori(bounding_box.position.y / fog.tile_set.tile_size.y))
	
	for x: int in fog_size_in_tiles.x:
		for y: int in fog_size_in_tiles.y:
			var coords: Vector2i = Vector2i(x + fog_tile_offset.x, y + fog_tile_offset.y)
			fog.set_cell(coords, 0, Vector2i(0,0))

func reveal_fog(tile_position: Vector2i) -> void:
	fog.set_cell(tile_position)
