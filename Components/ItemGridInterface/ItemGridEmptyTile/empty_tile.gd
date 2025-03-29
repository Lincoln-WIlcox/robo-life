class_name ItemGridEmptyTile
extends Control

var tile_area:
	get:
		return $ItemGridTileArea

const HIGHLIGHTED_COLOR = Color(2, 2, 2)

@export var grid_position: Vector2i
@export var highlighted := false:
	set(new_value):
		highlighted = new_value
		if highlighted:
			modulate = HIGHLIGHTED_COLOR
		else:
			modulate = Color.WHITE
@export var associated_item_grid: ItemGrid

var targeted_by_grid_item

func _ready():
	custom_minimum_size = Vector2(Utils.ITEM_GRID_TILE_SIZE, Utils.ITEM_GRID_TILE_SIZE)

func highlight(grid_item: ItemGridItem) -> void:
	targeted_by_grid_item = grid_item

func stop_highlighting() -> void:
	targeted_by_grid_item = null
