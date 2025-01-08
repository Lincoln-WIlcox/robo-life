extends Node

var enviornment_query_system: EnvironmentQuerySystem
var node_to_put_lines_in: Node

func _on_place_object_handler_placeable_placed(placeable):
	if placeable is PowerPole:
		placeable.add_to_enviornment_query_system(enviornment_query_system)

func _on_place_object_handler_placing_placeable(placeable):
	if placeable is PowerPole:
		placeable.node_to_put_lines_in = node_to_put_lines_in
