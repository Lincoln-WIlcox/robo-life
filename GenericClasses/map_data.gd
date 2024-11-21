class_name MapData
extends Resource

var _map_entities: Array[MapEntity]
var _tilemap_polygons: Array[PackedVector2Array]
var _bounding_box: Rect2

func _init(map_entities: Array[MapEntity], tilemap_polygons: Array[PackedVector2Array], bounding_box: Rect2):
	_map_entities = map_entities
	_tilemap_polygons = tilemap_polygons
	_bounding_box = bounding_box

func get_tilemap_polygons() -> Array[PackedVector2Array]:
	return _tilemap_polygons

func get_map_entities() -> Array[MapEntity]:
	return _map_entities

func get_bounding_box() -> Rect2:
	return _bounding_box
