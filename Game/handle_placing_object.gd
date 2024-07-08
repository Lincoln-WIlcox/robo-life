class_name PlaceObjectHandler
extends Node2D

var _placing_placeable: Placeable

signal object_placed(object: Placeable)

func start_placing_placeable(placeable: Placeable) -> void:
	_placing_placeable = placeable
	add_child(_placing_placeable)

func stop_placing() -> void:
	if _placing_placeable and _placing_placeable.is_inside_tree() and _placing_placeable.get_parent() == self:
		remove_child(_placing_placeable)
	_placing_placeable = null

func update_placing() -> void:
	_placing_placeable.global_position = get_global_mouse_position()

func attempt_place_object() -> bool:
	if _placing_placeable.placement_valid:
		remove_child(_placing_placeable)
		object_placed.emit(_placing_placeable)
		stop_placing()
		return true
	return false
