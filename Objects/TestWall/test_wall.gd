@tool
class_name TestWall
extends StaticBody2D

@export var shape: RectangleShape2D:
	set(new_value):
		shape = new_value
		
		if is_inside_tree():
			update_children()
			color_rect.queue_redraw()

@onready var collision_shape = $CollisionShape2D
@onready var color_rect = $ColorRect

func _ready():
	update_children()

func _process(delta):
	if Engine.is_editor_hint():
		update_children()

func update_children() -> void:
	collision_shape.shape = shape
	color_rect.size = shape.size
	color_rect.position.x = -shape.size.x / 2
	color_rect.position.y = -shape.size.y / 2
