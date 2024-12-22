@tool
class_name Rope
extends Node2D

@onready var sprite = $Sprite2D
@onready var area = $ClimbableArea

@export var height := 16:
	set(new_value):
		height = new_value
		
		if is_inside_tree():
			_update_sprite_and_area()

@export var tile_height: float:
	set(new_value):
		height = roundi(new_value * 16)
	get:
		return float(height) / 16

func _ready():
	_update_sprite_and_area()

func _update_sprite_and_area() -> void:
	sprite.region_rect.size.y = height
	area.height = height
