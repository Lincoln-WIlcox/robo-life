class_name MapData
extends Resource

var _map_entities: Array[MapEntity]
var _tilemap_polygons: Array[PackedVector2Array]

func _init(map_entities: Array[MapEntity], tilemap_polygons: Array[PackedVector2Array]):
	_map_entities = map_entities
	_tilemap_polygons = tilemap_polygons

func get_tilemap_polygons():
	return _tilemap_polygons

func get_map_entities():
	return _map_entities
