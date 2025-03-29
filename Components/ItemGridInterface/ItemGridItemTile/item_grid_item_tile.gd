class_name ItemGridItemTile
extends Control

@export var texture: Texture:
	set(new_value):
		texture = new_value
		_on_texture_set(texture)
@export var tile_size: Vector2i:
	set(new_value):
		tile_size = new_value
		_on_tile_size_set(tile_size)
@export var item_grid_item: ItemGridItem:
	set(new_value):
		item_grid_item = new_value
		_on_item_grid_item_set(item_grid_item)

func _ready():
	custom_minimum_size = Vector2(Utils.ITEM_GRID_TILE_SIZE, Utils.ITEM_GRID_TILE_SIZE)

func get_grid_position() -> Vector2i:
	return item_grid_item.position

func _on_tile_size_set(new_tile_size: Vector2i) -> void:
	$PanelContainer.custom_minimum_size = Vector2(new_tile_size.x * Utils.ITEM_GRID_TILE_SIZE, new_tile_size.y * Utils.ITEM_GRID_TILE_SIZE)
	$PanelContainer.position = Vector2.ZERO

func _on_texture_set(new_texture) -> void:
	$PanelContainer/MarginContainer/TextureRect.texture = new_texture

func _on_item_grid_item_set(new_item_grid_item) -> void:
	pass
