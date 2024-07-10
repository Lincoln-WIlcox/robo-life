class_name PlaceObjectHandler
extends Node2D

var mouse_detect_area: MouseDetectArea
var _placing_placeable: Placeable

signal placing_item(object: Placeable)

func start_placing_placeable(placeable: Placeable) -> void:
	_placing_placeable = placeable
	placing_item.emit(placeable)

func stop_placing() -> void:
	_placing_placeable = null

func cancel_placing() -> void:
	_placing_placeable.queue_free()
	_placing_placeable = null

func update_placing() -> void:
	_placing_placeable.global_position = get_global_mouse_position()
	_placing_placeable.in_range = mouse_detect_area.mouse_over

func attempt_place_object() -> bool:
	if _placing_placeable.placement_valid and mouse_detect_area.mouse_over:
		_placing_placeable.place()
		stop_placing()
		return true
	return false

