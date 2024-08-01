extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	global_position = get_global_mouse_position()

func is_overlapping_area(area: Area2D):
	if area in get_overlapping_areas():
		return true
	return false
