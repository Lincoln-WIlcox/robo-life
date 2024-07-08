class_name PlaceObjectHandler
extends Node2D

var placing_item: Placeable

func start_placing_placeable(placeable: Placeable) -> void:
	placing_item = placeable
	add_child(placing_item)

func stop_placing() -> void:
	placing_item = null

func update_placing() -> void:
	placing_item.global_position = get_global_mouse_position()
