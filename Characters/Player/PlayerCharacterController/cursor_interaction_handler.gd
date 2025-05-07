class_name MouseInteractionHandler
extends Node

var cursor_detect_area: CursorDetectArea
var cursor_interacted: Callable

signal interacted(mouse_interaction_area: MouseInteractionArea)

func update():
	var interaction_areas: Array[MouseInteractionArea]
	var interaction_areas_assigner: Array[Area2D] = MouseArea.get_overlapping_areas().filter(func(a: Area2D): return a is MouseInteractionArea)
	interaction_areas.assign(interaction_areas_assigner)
	
	if cursor_interacted.call() and interaction_areas.size() > 0:
		var highest_priority: int = interaction_areas.reduce(func(agg: int, area: MouseInteractionArea): return max(agg, area.pickup_priority), -INF)
		var areas_with_highest_priorty := interaction_areas.filter(func(area: MouseInteractionArea): return area.pickup_priority >= highest_priority)
		var mouse_interaction_area: MouseInteractionArea = areas_with_highest_priorty[0]
		
		_handle_interaction(mouse_interaction_area)

func _handle_interaction(mouse_interaction_area: MouseInteractionArea) -> void:
	if cursor_detect_area.overlaps_area(mouse_interaction_area):
		mouse_interaction_area.interact()
		interacted.emit(mouse_interaction_area)
		
		if not mouse_interaction_area.area_exited.is_connected(_on_mouse_interaction_area_area_exited):
			mouse_interaction_area.area_exited.connect(_on_mouse_interaction_area_area_exited.bind(mouse_interaction_area))
	else:
		mouse_interaction_area.interaction_out_of_range()

func _on_mouse_interaction_area_area_exited(area: Area2D, mouse_interaction_area: MouseInteractionArea) -> void:
	if area == cursor_detect_area:
		mouse_interaction_area.left_range()
		mouse_interaction_area.area_exited.disconnect(_on_mouse_interaction_area_area_exited)
