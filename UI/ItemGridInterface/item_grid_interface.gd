class_name ItemGridInterface
extends Control

@onready var grid_container = $CenterContainer/GridContainer
@onready var dragging: State = $StateMachine/Dragging
@onready var dragging_tile_over_manager = $DraggingTileOverManager

@export var empty_tile_packed_scene: PackedScene
@export var item_grid_tile_packed_scene: PackedScene
@export var margin_tile_packed_scene: PackedScene
@export var item_grid: ItemGrid:
	set(new_value):
		item_grid = new_value
		if is_node_ready():
			grid_container.columns = item_grid.size.x
			if not item_grid.changed.is_connected(update_grid):
				item_grid.changed.connect(update_grid)
			update_grid()

var tiles: Array[ItemGridTile]:
	get:
		var item_grid_tiles: Array[ItemGridTile]
		var nodes = grid_container.get_children().filter(func(n: Node): return n is ItemGridTile)
		item_grid_tiles.assign(nodes)
		return item_grid_tiles

var empty_tiles: Array[ItemGridEmptyTile]:
	get:
		var item_grid_tiles: Array[ItemGridEmptyTile]
		var nodes = grid_container.get_children().filter(func(n: Node): return n is ItemGridEmptyTile)
		item_grid_tiles.assign(nodes)
		return item_grid_tiles

var _updating_grid = false

signal item_dropped(grid_item: ItemGridItem)
signal tile_dragged(grid_item: ItemGridItem)

func _ready():
	if item_grid:
		grid_container.columns = item_grid.size.x
		item_grid.changed.connect(update_grid)
		update_grid()
	dragging.tiles = func(): return tiles
	dragging.empty_tiles = func(): return empty_tiles
	dragging.item_grid = func(): return item_grid
	dragging_tile_over_manager.tiles = func(): return tiles
	dragging_tile_over_manager.empty_tiles = func(): return empty_tiles
	dragging_tile_over_manager.item_grid = func(): return item_grid

#func open_gui() -> void:
	#show()
	#update_grid()

func close_gui() -> void:
	dragging.gui_exited()

func _physics_process(_delta):
	_updating_grid = false

func update_grid() -> void:
	if _updating_grid == false:
		_updating_grid = true
		remove_tiles()
		
		if grid_container.get_children().size() > 0:
			await grid_container.get_children()[grid_container.get_children().size() - 1].tree_exited
		
		for y: int in range(0, item_grid.size.y):
			for x: int in range(0, item_grid.size.x):
				var grid_position = Vector2i(x,y)
				
				var found_overlapping_grid_item := false
				
				for tile: ItemGridTile in tiles:
					if tile.item_grid_item.rect.has_point(grid_position):
						make_margin()
						found_overlapping_grid_item = true
						break
				
				if not found_overlapping_grid_item:
					for grid_item: ItemGridItem in item_grid.get_grid_items():
						if grid_item.position == grid_position:
							make_item_tile(grid_item)
							found_overlapping_grid_item = true
							break
				
				if not found_overlapping_grid_item:
					make_empty_tile(grid_position)
		

func remove_tiles() -> void:
	for child: Node in grid_container.get_children():
		child.queue_free()

func make_margin() -> void:
	var margin: MarginTile = margin_tile_packed_scene.instantiate()
	grid_container.add_child(margin)

func make_empty_tile(grid_position: Vector2i) -> void:
	var empty_tile = empty_tile_packed_scene.instantiate()
	empty_tile.grid_position = grid_position
	empty_tile.associated_item_grid = item_grid
	grid_container.add_child(empty_tile)
	#empty_tile.tile_area.area_entered.connect(dragging_tile_over_manager.on_tile_area_entered)
	#empty_tile.tile_area.area_exited.connect(dragging_tile_over_manager.on_tile_area_exited)

func make_item_tile(new_tile_grid_item: ItemGridItem) -> void:
	var item_grid_tile: ItemGridTile = item_grid_tile_packed_scene.instantiate()
	item_grid_tile.texture = new_tile_grid_item.item_data.texture
	item_grid_tile.tile_size = new_tile_grid_item.item_data.grid_size
	item_grid_tile.item_grid_item = new_tile_grid_item
	item_grid_tile.drop_pressed.connect(_on_item_tile_drop_pressed)
	item_grid_tile.dragged.connect(func(grid_item: ItemGridItem): tile_dragged.emit(grid_item))
	grid_container.add_child(item_grid_tile)

func _on_item_tile_drop_pressed(grid_item: ItemGridItem):
	item_dropped.emit(grid_item)
