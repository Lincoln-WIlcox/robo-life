extends Node

var tiles: Callable = func(): return []
var empty_tiles: Callable = func(): return []
var item_grid: Callable = func(): return ItemGrid.new()

func _physics_process(_delta):
	_remove_highlights()
	for empty_tile: ItemGridEmptyTile in empty_tiles.call():
		if empty_tile.targeted_by_grid_item:
			var placing_onto_tiles: Array
			for x: int in range(0, empty_tile.targeted_by_grid_item.item_data.grid_size.x):
				for y: int in range(0, empty_tile.targeted_by_grid_item.item_data.grid_size.y):
					var current_position: Vector2i = empty_tile.grid_position + Vector2i(x, y)
					for other_empty_tile: ItemGridEmptyTile in empty_tiles.call():
						if other_empty_tile.grid_position == current_position:
							placing_onto_tiles.append(other_empty_tile)
			for tile in placing_onto_tiles:
				tile.highlighted = true

func _remove_highlights():
	for tile: ItemGridEmptyTile in empty_tiles.call():
		tile.highlighted = false
