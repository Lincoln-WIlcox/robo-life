extends Node

var tiles: Callable = func(): return []
var empty_tiles: Callable = func(): return []
var item_grid: Callable = func(): return ItemGrid.new()

func _update_tiles(move_tile: MoveTileArea):
	_remove_highlights()
	
	var first_tile = get_placing_tile(move_tile)
	
	var placeable := false
	if first_tile:
		var placing_onto_tiles: Array
		var all_positions_empty := true
		var end = first_tile.grid_position + move_tile.grid_item.item_data.grid_size
		if end.x <= item_grid.call().size.x and end.y <= item_grid.call().size.y:
			for x: int in range(0, move_tile.grid_item.item_data.grid_size.x):
				for y: int in range(0, move_tile.grid_item.item_data.grid_size.y):
					var current_position: Vector2i = first_tile.grid_position + Vector2i(x, y)
					for tile: ItemGridTile in tiles.call():
						if tile.grid_position == current_position:
							all_positions_empty = false
							placing_onto_tiles.append(tile)
					for empty_tile: ItemGridEmptyTile in empty_tiles.call():
						if empty_tile.grid_position == current_position:
							placing_onto_tiles.append(empty_tile)
			if all_positions_empty:
				move_tile.on_placeable()
				placeable = true
				for tile in placing_onto_tiles:
					tile.highlighted = true
	
	if placeable == false:
		move_tile.on_not_placeable()

func get_placing_tile(move_tile: MoveTileArea):
	var item_grid_tile_areas: Array[Area2D] = move_tile.get_overlapping_areas().filter(func(a: Area2D): return a is ItemGridTileArea)
	var first_tile = null
	if item_grid_tile_areas.size() > 0:
		first_tile = item_grid_tile_areas.reduce(func(first_tile, area: ItemGridTileArea): return area.item_grid_tile if area.item_grid_tile.grid_position < first_tile.grid_position else first_tile, item_grid_tile_areas[0].item_grid_tile)
	return first_tile

func _remove_highlights():
	for tile: ItemGridEmptyTile in empty_tiles.call():
		tile.highlighted = false

func on_tile_area_entered(area: Area2D):
	if area is MoveTileArea:
		await get_tree().physics_frame
		_update_tiles(area)

func on_tile_area_exited(area: Area2D):
	if area is MoveTileArea:
		if area.is_queued_for_deletion():
			_remove_highlights()
			return
		await get_tree().physics_frame
		_update_tiles(area)