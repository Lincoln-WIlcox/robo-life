class_name ItemGridTile
extends Control

const TILE_SIZE = 64

@export var texture: Texture:
	set(new_value):
		$PanelContainer/VBoxContainer/MarginContainer/TextureRect.texture = new_value
@export var tile_size: Vector2i:
	set(new_value):
		$PanelContainer.custom_minimum_size = Vector2(new_value.x * TILE_SIZE, new_value.y * TILE_SIZE)
@export var item_grid_item: ItemGridItem

signal drop_pressed
