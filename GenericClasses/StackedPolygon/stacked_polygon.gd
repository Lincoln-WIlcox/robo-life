class_name StackedPolygon
extends RefCounted

##Represents an individual polygon without contained polygons on the stack.

var bounds: PackedVector2Array
var is_hole: bool = false

func _init(init_bounds: PackedVector2Array = []):
	bounds = init_bounds
