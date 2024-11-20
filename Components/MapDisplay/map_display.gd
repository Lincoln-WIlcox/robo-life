class_name MapDisplay
extends Control

@onready var node_to_put_map_in: Node2D = $MapMargin/MapPanel/MapPadding/MapContainer/ScrollableContainer

func _display_polygons(packed_vectors: Array[PackedVector2Array]) -> void:
	var polygons: Array[Polygon2D] = Utils.packed_vector_arrays_to_polygons(packed_vectors)
	var polygons_assigned: Array[Node]
	polygons_assigned.assign(polygons)
	Utils.add_children(node_to_put_map_in, polygons_assigned)

func display_map_data(map_data: MapData) -> void:
	_display_polygons(map_data.get_tilemap_polygons())
