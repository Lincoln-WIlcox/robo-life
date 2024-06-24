extends Node

@export var interactor: Node
@export var detector_area: Area2D

signal interacted_with_area(interaction_area: InteractionArea)

func _on_player_character_just_interacted():
	var interaction_areas: Array = detector_area.get_overlapping_areas().filter(func(area): return area is InteractionArea and area.disabled == false)
	
	if interaction_areas.size() > 0:
		var highest_priority: int = interaction_areas.reduce(func(agg, area): return max(agg, area.interaction_priority), -INF)
		var areas_with_highest_priorty = interaction_areas.filter(func(area): return area.interaction_priority >= highest_priority)
		interacted_with_area.emit(areas_with_highest_priorty[0])
