class_name Placeable
extends Node2D

const IN_RANGE_COLOR = Color(.5,1,.5,.5)
const OUT_OF_RANGE_COLOR = Color(1,.5,.5,.5)

var placement_valid := true:
	set(new_value):
		placement_valid = new_value
		update_color()
var _placed := false:
	set(new_value):
		if new_value and not _placed:
			_on_placed()
		_placed = new_value
var in_range := true:
	set(new_value):
		in_range = new_value
		update_color()

func _ready():
	update_color()

func _on_placed():
	modulate = Color(1,1,1)

func update_color():
	if _placed:
		modulate = Color(1,1,1)
	elif placement_valid and in_range:
		modulate = IN_RANGE_COLOR
	else:
		modulate = OUT_OF_RANGE_COLOR

func place():
	_placed = true
