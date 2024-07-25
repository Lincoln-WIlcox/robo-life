class_name ItemGridTileArea
extends Area2D

@export var item_grid_tile: Control
@export var size := Vector2i(1,1):
	set(new_value):
		make_unique()
		size = new_value
		$CollisionShape2D.shape.size = Vector2(Utils.ITEM_GRID_TILE_SIZE * size.x, Utils.ITEM_GRID_TILE_SIZE * size.y)
		$CollisionShape2D.position = Vector2(Utils.ITEM_GRID_TILE_SIZE * size.x / 2, Utils.ITEM_GRID_TILE_SIZE * size.y / 2)

var grid_position: Vector2i

func _ready():
	make_unique()

func make_unique():
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
