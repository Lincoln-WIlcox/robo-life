class_name MoveTileArea
extends Area2D

const PLACEABLE_COLOR = Color(0,1,0,.5)
const NOT_PLACEABLE_COLOR = Color(1,0,0,.5)

@onready var color_rect: ColorRect = $ColorRect

@export var grid_item: ItemGridItem:
	set(new_value):
		grid_item = new_value
		var grid_size = grid_item.item_data.grid_size
		$ColorRect.size = Vector2(grid_size.x * Utils.ITEM_GRID_TILE_SIZE, grid_size.y * Utils.ITEM_GRID_TILE_SIZE)
		$CollisionShape2D.shape.size = Vector2(grid_size.x * Utils.ITEM_GRID_TILE_SIZE, grid_size.y * Utils.ITEM_GRID_TILE_SIZE)
		$CollisionShape2D.position = Vector2(grid_size.x * Utils.ITEM_GRID_TILE_SIZE / 2, grid_size.y * Utils.ITEM_GRID_TILE_SIZE / 2)

func on_placeable():
	color_rect.modulate = PLACEABLE_COLOR

func on_not_placeable():
	color_rect.modulate = NOT_PLACEABLE_COLOR
