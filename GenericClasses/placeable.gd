class_name Placeable
extends Node2D

const IN_RANGE_COLOR = Color(1,1,1,.5)
const OUT_OF_RANGE_COLOR = Color(1,.2,.2,.5)

var placement_valid := true
var _placed := false:
	set(new_value):
		if new_value and not _placed:
			_on_placed()
		_placed = new_value
var in_range := true:
	set(new_value):
		if in_range and not new_value:
			pass
		elif not in_range and new_value:
			pass
		in_range = new_value

func _on_placed():
	modulate = Color(1,1,1)

func _on_in_range():
	modulate = IN_RANGE_COLOR

func _on_out_of_range():
	modulate = OUT_OF_RANGE_COLOR

func place():
	_placed = true
