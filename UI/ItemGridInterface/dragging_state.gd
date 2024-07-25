extends State

@export var move_tile_area_packed_scene: PackedScene
@export var none_state: State
@export var node_to_put_color_rect_in: Control

var grid_item: ItemGridItem
var tiles: Callable = func(): return []
var empty_tiles: Callable = func(): return []
var item_grid: Callable = func(): return ItemGrid.new()

var _move_tile_area: MoveTileArea

signal placed_tile
signal removed_item

func enter():
	_move_tile_area = move_tile_area_packed_scene.instantiate()
	_move_tile_area.grid_size = grid_item.item_data.grid_size
	_move_tile_area.area_entered.connect(_on_move_tile_area_area_entered)
	_move_tile_area.area_exited.connect(_on_move_tile_area_area_exited)
	item_grid.call().remove_grid_item(grid_item)
	removed_item.emit()
	node_to_put_color_rect_in.add_child(_move_tile_area)

func run():
	if not Input.is_action_pressed("drag_item"):
		state_ended.emit(none_state)
		return
	
	_move_tile_area.global_position = _move_tile_area.get_global_mouse_position()

func exit():
	var first_tile = get_placing_tile()
	if first_tile:
		item_grid.call().add_item_at_position(grid_item.item_data, first_tile.grid_position)
	else:
		item_grid.call().add_item_at_position(grid_item.item_data, grid_item.position)
	placed_tile.emit()
	
	_move_tile_area.queue_free()
	_remove_highlights()

func _update_tiles():
	_remove_highlights()
	
	var first_tile = get_placing_tile()
	
	var placeable := false
	if first_tile:
		var placing_onto_tiles: Array
		var all_positions_empty := true
		var end = first_tile.grid_position + grid_item.item_data.grid_size
		if end.x <= item_grid.call().size.x and end.y <= item_grid.call().size.y:
			for x: int in range(0, grid_item.item_data.grid_size.x):
				for y: int in range(0, grid_item.item_data.grid_size.y):
					var current_position: Vector2i = first_tile.grid_position + Vector2i(x, y)
					for tile: ItemGridTile in tiles.call():
						if tile.grid_position == current_position:
							all_positions_empty = false
							placing_onto_tiles.append(tile)
					for empty_tile: ItemGridEmptyTile in empty_tiles.call():
						if empty_tile.grid_position == current_position:
							placing_onto_tiles.append(empty_tile)
			if all_positions_empty:
				_move_tile_area.on_placeable()
				placeable = true
				for tile in placing_onto_tiles:
					tile.highlighted = true
	
	if placeable == false:
		_move_tile_area.on_not_placeable()

func get_placing_tile():
	var item_grid_tile_areas: Array[Area2D] = _move_tile_area.get_overlapping_areas().filter(func(a: Area2D): return a is ItemGridTileArea)
	var first_tile = null
	if item_grid_tile_areas.size() > 0:
		first_tile = item_grid_tile_areas.reduce(func(first_tile, area: ItemGridTileArea): return area.item_grid_tile if area.item_grid_tile.grid_position < first_tile.grid_position else first_tile, item_grid_tile_areas[0].item_grid_tile)
	return first_tile

func _remove_highlights():
	for tile: ItemGridEmptyTile in empty_tiles.call():
		tile.highlighted = false

func _on_move_tile_area_area_entered(area: Area2D):
	if is_current_state.call():
		_update_tiles()

func _on_move_tile_area_area_exited(area: Area2D):
	if is_current_state.call():
		_update_tiles()
