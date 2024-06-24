class_name FixedToPixelGrid
extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = Vector2.ZERO
	global_position = round(global_position)
