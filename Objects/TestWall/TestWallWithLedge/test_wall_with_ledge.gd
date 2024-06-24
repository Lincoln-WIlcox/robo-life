@tool
class_name TestWallWithLedge
extends TestWall

@onready var left_ledge = $LeftLedge
@onready var right_ledge = $RightLedge

func update_children() -> void:
	super()
	left_ledge.position = color_rect.position
	right_ledge.position = Vector2(color_rect.position.x + color_rect.size.x, color_rect.position.y)
