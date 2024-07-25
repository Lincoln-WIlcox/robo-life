class_name ItemGridTile
extends Control

@export var texture: Texture:
	set(new_value):
		$PanelContainer/VBoxContainer/MarginContainer/TextureRect.texture = new_value
@export var tile_size: Vector2i:
	set(new_value):
		$PanelContainer.custom_minimum_size = Vector2(new_value.x * Utils.ITEM_GRID_TILE_SIZE, new_value.y * Utils.ITEM_GRID_TILE_SIZE)
		$ItemGridTileArea.size = new_value
@export var item_grid_item: ItemGridItem:
	set(new_value):
		item_grid_item = new_value
		$ItemGridTileArea.grid_position = item_grid_item.position
@export var grid_position: Vector2i:
	get:
		return item_grid_item.position

signal dragged(grid_item: ItemGridItem)
signal drop_pressed(item_data: ItemGridItem)

func _on_button_pressed():
	drop_pressed.emit(item_grid_item)

func _on_margin_container_dragged():
	dragged.emit(item_grid_item)
