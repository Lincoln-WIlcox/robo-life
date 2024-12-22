class_name ItemGridTileArea
extends Area2D

@export var item_grid_tile: Control
@export var size := Vector2i(1,1):
	set(new_value):
		_make_unique()
		size = new_value
		_set_size()

var grid_position: Vector2i

func _ready():
	_make_unique()
	_set_size()

func _set_size():
	$CollisionShape2D.shape.size = Vector2(Utils.ITEM_GRID_TILE_SIZE * size.x, Utils.ITEM_GRID_TILE_SIZE * size.y)
	$CollisionShape2D.position = Vector2(Utils.ITEM_GRID_TILE_SIZE * size.x / 2.0, Utils.ITEM_GRID_TILE_SIZE * size.y / 2.0)

func _make_unique():
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
