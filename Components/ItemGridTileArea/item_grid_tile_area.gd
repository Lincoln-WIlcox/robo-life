class_name ItemGridTileArea
extends Area2D

var grid_position: Vector2i

func _ready():
	$CollisionShape2D.shape.size = Vector2(Utils.ITEM_GRID_TILE_SIZE, Utils.ITEM_GRID_TILE_SIZE)
	$CollisionShape2D.position = Vector2(Utils.ITEM_GRID_TILE_SIZE / 2, Utils.ITEM_GRID_TILE_SIZE / 2)
