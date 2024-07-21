class_name ItemGridTile
extends Control

const TILE_SIZE = 48

@export var texture: Texture:
	set(new_value):
		$PanelContainer/MarginContainer/TextureRect.texture = new_value
@export var tile_size: Vector2i:
	set(new_value):
		$PanelContainer.custom_minimum_size = Vector2(new_value.x * TILE_SIZE, new_value.y * TILE_SIZE)
@export var item_grid_item: ItemGridItem
