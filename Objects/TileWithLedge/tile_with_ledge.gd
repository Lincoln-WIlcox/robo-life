@tool
extends StaticBody2D

@export var ledge_packed_scene: PackedScene
@export_flags("Left", "Right") var sides: int:
	set(new_value):
		sides = new_value
		
		if is_inside_tree():
			_update_ledge()

# Called when the node enters the scene tree for the first time.
func _ready():
	print(sides)
	_update_ledge()

func _update_ledge() -> void:
	_remove_ledges()
	if sides & Global.GrabDirections.LEFT:
		var ledge: Ledge = ledge_packed_scene.instantiate()
		ledge.position = Vector2(-8, -8)
		ledge.grab_direction = Global.GrabDirections.LEFT
		add_child(ledge)
	if sides & Global.GrabDirections.RIGHT:
		var ledge: Ledge = ledge_packed_scene.instantiate()
		ledge.position = Vector2(8, -8)
		ledge.grab_direction = Global.GrabDirections.RIGHT
		add_child(ledge)
	

func _remove_ledges():
	for child in get_children():
		if child is Ledge:
			remove_child(child)
			child.queue_free()
