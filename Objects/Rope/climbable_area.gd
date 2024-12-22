@tool
class_name ClimbableArea
extends Area2D

const ROPE_WIDTH = 16

@onready var collision_box = $CollisionShape2D

@export var height: int:
	set(new_value):
		height = new_value
		
		if is_inside_tree() and collision_box.shape:
			_update_size_and_position()

@export var tile_height: float:
	set(new_value):
		tile_height = new_value
		height = new_value * 16.0
	get:
		return float(height) / 16

var top_of_climbable: int:
	get:
		return global_position.y - (collision_box.shape.size.y / 2)

var bottom_of_climbable: int:
	get:
		return global_position.y + (collision_box.shape.size.y / 2)

func _ready():
	_create_collision_shape()
	_update_size_and_position()

func _create_collision_shape() -> void:
	collision_box.shape = RectangleShape2D.new()
	collision_box.shape.size.x = ROPE_WIDTH

func _update_size_and_position() -> void:
	collision_box.shape.size.y = height
	position.y = height / 2.0
