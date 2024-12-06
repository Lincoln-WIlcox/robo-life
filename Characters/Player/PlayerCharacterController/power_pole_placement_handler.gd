extends Node

var enviornment_query_system: EnvironmentQuerySystem

func _on_place_object_handler_placeable_placed(placeable):
	if placeable is PowerPole:
		placeable.add_to_enviornment_query_system(enviornment_query_system)
