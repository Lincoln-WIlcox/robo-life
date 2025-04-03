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

var _placing_tile

func on_placeable():
	color_rect.modulate = PLACEABLE_COLOR

func on_not_placeable():
	color_rect.modulate = NOT_PLACEABLE_COLOR

func _physics_process(_delta):
	var new_placing_tile = Utils.get_placing_tile(self)
	if new_placing_tile and _can_place_on_new_tile(new_placing_tile):
		if new_placing_tile != _placing_tile:
			_change_placing_tile(new_placing_tile)
		on_placeable()
	else:
		if _placing_tile:
			_stop_placing_tile()
		on_not_placeable()

func _can_place_on_new_tile(new_placing_tile) -> bool:
	var initial_position := grid_item.position
	grid_item.position = new_placing_tile.grid_position
	var can_place: bool = new_placing_tile.associated_item_grid.item_grid_item_can_be_added(grid_item)
	grid_item.position = initial_position
	#print(can_place)
	return can_place
	

func _exit_tree():
	if _placing_tile != null:
		_placing_tile.highlighted = false

func _change_placing_tile(new_placing_tile):
	if _placing_tile:
		_stop_placing_tile()
	_placing_tile = new_placing_tile
	_placing_tile.highlight(grid_item)

func _stop_placing_tile():
	_placing_tile.stop_highlighting()
	_placing_tile = null
