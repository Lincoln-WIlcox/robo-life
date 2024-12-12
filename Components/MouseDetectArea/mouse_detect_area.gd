class_name MouseDetectArea
extends Area2D

var mouse_over:
	get:
		return is_mouse_over()

signal clicked

func is_mouse_over():
	var overlapping_areas = get_overlapping_areas()
	for area: Area2D in overlapping_areas:
		if area.is_in_group("MouseArea"):
			return true
	return false

func _input(event):
	if event.is_action_pressed("cursor_interact") and mouse_over:
		clicked.emit()
