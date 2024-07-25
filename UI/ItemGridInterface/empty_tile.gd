class_name ItemGridEmptyTile
extends Control

const HIGHLIGHTED_COLOR = Color(2, 2, 2)

@export var grid_position: Vector2i
@export var highlighted := false:
	set(new_value):
		highlighted = new_value
		if highlighted:
			modulate = HIGHLIGHTED_COLOR
		else:
			modulate = Color.WHITE
