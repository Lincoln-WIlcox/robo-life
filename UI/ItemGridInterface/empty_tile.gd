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

func _ready():
	custom_minimum_size = Vector2(Utils.ITEM_GRID_TILE_SIZE, Utils.ITEM_GRID_TILE_SIZE)
