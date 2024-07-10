class_name Placeable
extends Node2D

var placement_valid := true
var _placed := false:
	set(new_value):
		if new_value and not _placed:
			on_placed()
		_placed = new_value

func on_placed():
	pass

func place():
	_placed = true
