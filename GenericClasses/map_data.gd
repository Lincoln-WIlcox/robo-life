class_name MapData
extends Object

var _map_entities: Array[MapEntity]
var _tilemap_polygons: Array[PackedVector2Array]

func _init(map_entities: Array[MapEntity], tilemap_polygons: Array[PackedVector2Array]):
	_map_entities = map_entities
	_tilemap_polygons = tilemap_polygons
