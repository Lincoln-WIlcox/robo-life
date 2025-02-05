extends Node

var node_to_put_transport_buckets_in: Node
var environment_query_system: EnvironmentQuerySystem
var show_ui: Callable
var hide_ui: Callable
var get_revealed_sectors: Callable

signal sector_revealed(sector_coords: Vector2i)

func _on_place_object_handler_placing_placeable(placeable):
	if placeable is TransportBucketPlaceable:
		placeable.node_to_put_transport_buckets_in = node_to_put_transport_buckets_in
		placeable.show_ui = show_ui
		placeable.hide_ui = hide_ui
		placeable.environment_query_system = environment_query_system
		placeable.get_revealed_sectors = get_revealed_sectors
		placeable.sector_revealed_signal = sector_revealed

func _on_sector_handler_sector_revealed(sector_coords: Vector2i):
	sector_revealed.emit(sector_coords)
