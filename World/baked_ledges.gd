@tool
class_name LedgeBaker
extends Node2D

@export var ledge_packed_scene: PackedScene

enum LedgeGrabbingBitFlags {
	LEFT = 1 << 0,
	RIGHT = 1 << 1
}

const PHYSICS_LAYER = 0
const DONT_BAKE_LEDGE_CUSTOM_DATA_INDEX = 0

const SQUARE_COLLISION_POINTS = [
	Vector2(-1,-1),
	Vector2(1,-1),
	Vector2(1,1),
	Vector2(-1,1)
]

const RELATIVE_TILES_POS_OBSTRUCTING_GRAB_LEFT = [
	Vector2i(-1,0),
	Vector2i(-1,-1),
	Vector2i(0,-1)
]

const RELATIVE_TILES_POS_OBSTRUCTING_GRAB_RIGHT = [
	Vector2i(1,0),
	Vector2i(1,-1),
	Vector2i(0,-1)
]

func bake_ledges(tile_map_layer: TileMapLayer) -> void:
	Utils.free_children(self)
	
	var cells: Array[Vector2i] = tile_map_layer.get_used_cells()
	var cell_size: Vector2i = tile_map_layer.tile_set.tile_size
	
	for tile_position: Vector2i in cells:
		var tile: TileData = tile_map_layer.get_cell_tile_data(tile_position)
		
		if _tile_is_solid_square(tile, cell_size) and not tile.get_custom_data_by_layer_id(DONT_BAKE_LEDGE_CUSTOM_DATA_INDEX):
			var ledge_sides: int = _ledge_grab_sides(tile_map_layer, tile_position)
			
			if Utils.is_bit_set(ledge_sides, LedgeGrabbingBitFlags.LEFT):
				var left_ledge_pos: Vector2 = Vector2(tile_position) * Vector2(cell_size)
				_make_ledge_at(left_ledge_pos)
			
			if Utils.is_bit_set(ledge_sides, LedgeGrabbingBitFlags.RIGHT):
				var right_ledge_pos: Vector2 = Vector2(tile_position) * Vector2(cell_size)
				right_ledge_pos.x += cell_size.x
				_make_ledge_at(right_ledge_pos)

#returns bit flags representing sides which has space for ledge grabbing.
func _ledge_grab_sides(tile_map_layer: TileMapLayer, tile_pos: Vector2i) -> int:
	var grabbable_sides: int = 0
	grabbable_sides = Utils.set_bit(grabbable_sides, LedgeGrabbingBitFlags.LEFT)
	grabbable_sides = Utils.set_bit(grabbable_sides, LedgeGrabbingBitFlags.RIGHT)
	
	for relative_tile_pos: Vector2i in RELATIVE_TILES_POS_OBSTRUCTING_GRAB_LEFT:
		var tile: TileData = tile_map_layer.get_cell_tile_data(tile_pos + relative_tile_pos)
		if tile and tile.get_collision_polygons_count(PHYSICS_LAYER) > 0:
			grabbable_sides = Utils.unset_bit(grabbable_sides, LedgeGrabbingBitFlags.LEFT)
			break
	
	for relative_tile_pos: Vector2i in RELATIVE_TILES_POS_OBSTRUCTING_GRAB_RIGHT:
		var tile: TileData = tile_map_layer.get_cell_tile_data(tile_pos + relative_tile_pos)
		if tile and tile.get_collision_polygons_count(PHYSICS_LAYER) > 0:
			grabbable_sides = Utils.unset_bit(grabbable_sides, LedgeGrabbingBitFlags.RIGHT)
			break
	
	return grabbable_sides

func _tile_is_solid_square(tile: TileData, cell_size: Vector2) -> bool:
	if tile.get_collision_polygons_count(PHYSICS_LAYER) > 0:
		var collision_points = tile.get_collision_polygon_points(PHYSICS_LAYER, 0)
		
		for collision_point: Vector2 in SQUARE_COLLISION_POINTS:
			if not collision_points.has(collision_point * cell_size / 2):
				return false
	else:
		return false
	return true

#pos should be global
func _make_ledge_at(pos: Vector2) -> void:
	var ledge: Ledge = ledge_packed_scene.instantiate()
	ledge.global_position = pos
	add_child(ledge)
	ledge.set_owner(get_tree().edited_scene_root)
