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
	#_move_tile_area.area_entered.connect(_on_move_tile_area_area_entered)
	#_move_tile_area.area_exited.connect(_on_move_tile_area_area_exited)
	_move_tile_area.grid_item = grid_item
	item_grid.call().remove_grid_item(grid_item)
	removed_item.emit()
	node_to_put_color_rect_in.add_child(_move_tile_area)

func run():
	if not Input.is_action_pressed("drag_item"):
		state_ended.emit(none_state)
		return
	
	_move_tile_area.global_position = _move_tile_area.get_global_mouse_position()

func exit():
	var first_tile = Utils.get_placing_tile(_move_tile_area)
	var placed_tile_on_grid := false
	var initial_position := grid_item.position
	if first_tile is ItemGridEmptyTile:
		grid_item.position = first_tile.grid_position
		if first_tile.associated_item_grid.item_grid_item_can_be_added(grid_item):
			first_tile.associated_item_grid.add_grid_item(grid_item)
			placed_tile_on_grid = true
	if not placed_tile_on_grid:
		grid_item.position = initial_position
		item_grid.call().add_grid_item(grid_item)
	placed_tile.emit()
	_move_tile_area.queue_free()

func gui_exited():
	if is_current_state.call():
		item_grid.call().add_grid_item(grid_item)
