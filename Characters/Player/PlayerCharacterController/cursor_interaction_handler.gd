class_name MouseInteractionHandler
extends Node

var mouse_detect_area: MouseDetectArea
var cursor_interacted: Callable

signal interacted(mouse_interaction_area: MouseInteractionArea)

func update():
	var interaction_areas: Array[MouseInteractionArea]
	var interaction_areas_assigner: Array[Area2D] = MouseArea.get_overlapping_areas().filter(func(a: Area2D): return a is MouseInteractionArea)
	interaction_areas.assign(interaction_areas_assigner)
	
	if cursor_interacted.call() and interaction_areas.size() > 0:
		var highest_priority: int = interaction_areas.reduce(func(agg: int, area: MouseInteractionArea): return max(agg, area.pickup_priority), -INF)
		var areas_with_highest_priorty := interaction_areas.filter(func(area: MouseInteractionArea): return area.pickup_priority >= highest_priority)
		var interaction_area: MouseInteractionArea = areas_with_highest_priorty[0]
		
		if mouse_detect_area.mouse_over:
			interaction_area.interact()
		else:
			interaction_area.interaction_out_of_range()