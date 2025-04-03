class_name ItemGridInterface
extends Control

@onready var grid_container = $CenterContainer/GridContainer

@export var empty_tile_packed_scene: PackedScene
@export var margin_tile_packed_scene: PackedScene
@export var display_tile_packed_scene: PackedScene
@export var item_grid: ItemGrid:
	set(new_value):
		item_grid = new_value
		if is_node_ready():
			grid_container.columns = item_grid.size.x
			if not item_grid.changed.is_connected(update_grid):
				item_grid.changed.connect(update_grid)
			update_grid()

var tiles: Array[ItemGridItemTile]:
	get:
		var item_grid_tiles: Array[ItemGridItemTile]
		var nodes = grid_container.get_children().filter(func(n: Node): return n is ItemGridItemTile)
		item_grid_tiles.assign(nodes)
		return item_grid_tiles

var empty_tiles: Array[ItemGridEmptyTile]:
	get:
		var item_grid_tiles: Array[ItemGridEmptyTile]
		var nodes = grid_container.get_children().filter(func(n: Node): return n is ItemGridEmptyTile)
		item_grid_tiles.assign(nodes)
		return item_grid_tiles

var _updating_grid = false

func _ready():
	if item_grid:
		grid_container.columns = item_grid.size.x
		item_grid.changed.connect(update_grid)
		update_grid()

func update_grid() -> void:
	if _updating_grid == false:
		_updating_grid = true
		_remove_tiles()
		
		_make_tiles.call_deferred()

func _enter_tree():
	if not is_node_ready():
		await ready
	update_grid()

func _make_tiles() -> void:
	for y: int in range(0, item_grid.size.y):
		for x: int in range(0, item_grid.size.x):
			var grid_position = Vector2i(x,y)
			
			var found_overlapping_grid_item := false
			
			#if previously made tile overlaps position, make margin tile
			for tile: ItemGridItemTile in tiles:
				if tile.item_grid_item.rect.has_point(grid_position):
					_make_margin()
					found_overlapping_grid_item = true
					break
			
			#if item grid has item at position, make item tile
			if not found_overlapping_grid_item:
				for grid_item: ItemGridItem in item_grid.get_grid_items():
					if grid_item.position == grid_position:
						_make_item_tile(grid_item)
						found_overlapping_grid_item = true
						break
			
			if not found_overlapping_grid_item:
				_make_empty_tile(grid_position)
			
	_updating_grid = false

func _remove_tiles() -> void:
	for child: Node in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()

func _make_margin() -> void:
	var margin: MarginTile = margin_tile_packed_scene.instantiate()
	grid_container.add_child(margin)

func _make_empty_tile(grid_position: Vector2i) -> void:
	var empty_tile = empty_tile_packed_scene.instantiate()
	empty_tile.grid_position = grid_position
	empty_tile.associated_item_grid = item_grid
	grid_container.add_child(empty_tile)

func _make_item_tile(new_tile_grid_item: ItemGridItem) -> void:
	var item_grid_tile: ItemGridItemTile = display_tile_packed_scene.instantiate()
	item_grid_tile.texture = new_tile_grid_item.item_data.texture
	item_grid_tile.tile_size = new_tile_grid_item.item_data.grid_size
	item_grid_tile.item_grid_item = new_tile_grid_item
	grid_container.add_child(item_grid_tile)
