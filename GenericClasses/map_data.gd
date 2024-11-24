class_name MapData
extends Resource

##Represents data to be displayed on a map. Includes polygons that represents solidity and map entities. See [MapEntity].
##Bounding box represents how far you can pan the map. It must be set when creating the class.

var _map_entities: Array[MapEntity]
var _solidity_polygons: Array[PackedVector2Array]
var _bounding_box: Rect2

##Emitted when the map should redraw the solidity.
signal solidity_changed
##Emitted when a map entity is added.
signal map_entity_added(added_entity: MapEntity)
##Emitted when a map entity is removed.
signal map_entity_removed(removed_entity: MapEntity)

func _init(map_entities: Array[MapEntity], solidity_polygons: Array[PackedVector2Array], bounding_box: Rect2):
	_map_entities = map_entities
	_solidity_polygons = solidity_polygons
	_bounding_box = bounding_box

func get_solidity_polygons() -> Array[PackedVector2Array]:
	return _solidity_polygons

func get_map_entities() -> Array[MapEntity]:
	return _map_entities

func get_bounding_box() -> Rect2:
	return _bounding_box

func add_solidity_polygon(polygon: PackedVector2Array) -> void:
	_solidity_polygons.append(polygon)
	solidity_changed.emit()

func add_map_entity(map_entity: MapEntity) -> void:
	_map_entities.append(map_entity)
	map_entity_added.emit(map_entity)

func map_entity_in_data(map_entity: MapEntity) -> bool:
	return _map_entities.find(map_entity) != -1

func remove_map_entity(map_entity: MapEntity) -> void:
	var index: int = _map_entities.find(map_entity)
	assert(index != -1, "map entity not in map data")
	_map_entities.remove_at(index)
	map_entity_removed.emit(map_entity)
