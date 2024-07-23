class_name GridTile
extends Control

@export var grid_position: Vector2i:
	set(new_value):
		grid_position = new_value
		$ItemGridTileArea.grid_position = new_value
