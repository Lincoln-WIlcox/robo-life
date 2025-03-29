class_name DraggableItemGridInterface
extends ItemGridInterface

@onready var dragging: State = $StateMachine/Dragging
@onready var dragging_tile_over_manager = $DraggingTileOverManager

@export var item_grid_tile_packed_scene: PackedScene

signal item_dropped(grid_item: ItemGridItem)
signal tile_dragged(grid_item: ItemGridItem)

func _ready():
	super()
	dragging.tiles = func(): return tiles
	dragging.empty_tiles = func(): return empty_tiles
	dragging.item_grid = func(): return item_grid
	dragging_tile_over_manager.tiles = func(): return tiles
	dragging_tile_over_manager.empty_tiles = func(): return empty_tiles
	dragging_tile_over_manager.item_grid = func(): return item_grid

func close_gui() -> void:
	dragging.gui_exited()

func _make_item_tile(new_tile_grid_item: ItemGridItem) -> void:
	var item_grid_tile: ItemGridInteractableTile = item_grid_tile_packed_scene.instantiate()
	item_grid_tile.texture = new_tile_grid_item.item_data.texture
	item_grid_tile.tile_size = new_tile_grid_item.item_data.grid_size
	item_grid_tile.item_grid_item = new_tile_grid_item
	item_grid_tile.drop_pressed.connect(_on_item_tile_drop_pressed)
	item_grid_tile.dragged.connect(
		func(grid_item: ItemGridItem): 
			tile_dragged.emit(grid_item)
			)
	grid_container.add_child(item_grid_tile)

func _on_item_tile_drop_pressed(grid_item: ItemGridItem):
	item_dropped.emit(grid_item)
