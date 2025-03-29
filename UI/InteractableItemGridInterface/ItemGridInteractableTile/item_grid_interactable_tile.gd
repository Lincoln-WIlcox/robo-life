class_name ItemGridInteractableTile
extends ItemGridItemTile

var tile_area:
	get:
		return $ItemGridTileArea

signal dragged(grid_item: ItemGridItem)
signal drop_pressed(item_data: ItemGridItem)

func _on_button_pressed():
	drop_pressed.emit(item_grid_item)

func _on_margin_container_dragged():
	dragged.emit(item_grid_item)

func _ready():
	custom_minimum_size = Vector2(Utils.ITEM_GRID_TILE_SIZE, Utils.ITEM_GRID_TILE_SIZE)

func _on_tile_size_set(new_tile_size) -> void:
	super(new_tile_size)
	$ItemGridTileArea.size = new_tile_size

func _on_item_grid_item_set(new_item_grid_item) -> void:
	super(new_item_grid_item)
	$ItemGridTileArea.grid_position = new_item_grid_item.position

func _on_texture_set(new_texture: Texture) -> void:
	$PanelContainer/VBoxContainer/MarginContainer/TextureRect.texture = new_texture
