class_name MapData
extends Resource

##Represents data to be displayed on a map. Includes polygons that represents solidity and map entities. See [MapEntity].
##Bounding box represents how far you can pan the map. It must be set when creating the class.

##When true, the resource will use the exported initial values instead of values passed to _init.
@export var use_exported_initial_values: bool = false
@export var initial_map_entities: Array[MapEntity]:
	set(new_value):
		initial_map_entities = new_value
		if new_value:
			_map_entities = new_value
@export var initial_solidity_polygons: Array[PackedVector2Array]:
	set(new_value):
		initial_solidity_polygons = new_value
		if new_value:
			_solidity_polygons = new_value
@export var initial_bounding_box: Rect2:
	set(new_value):
		initial_bounding_box = new_value
		if new_value:
			_bounding_box = new_value
@export var initial_revealed_sectors: Array[Vector2i]

var _map_entities: Array[MapEntity]
var _solidity_polygons: Array[PackedVector2Array]
var _bounding_box: Rect2
var _revealed_sectors: Array[Vector2i]

##Emitted when the map should redraw the solidity.
signal solidity_changed
##Emitted when a map entity is added.
signal map_entity_added(added_entity: MapEntity)
##Emitted when a map entity is removed.
signal map_entity_removed(removed_entity: MapEntity)
signal sector_revealed(sector_coords: Vector2i)

func _init(map_entities: Array[MapEntity] = [], solidity_polygons: Array[PackedVector2Array] = [], bounding_box: Rect2 = Rect2(), revealed_sectors: Array[Vector2i] = []):
	if !use_exported_initial_values:
		_map_entities = map_entities.duplicate()
		for map_entity: MapEntity in map_entities:
			map_entity.source_removed.connect(remove_map_entity.bind(map_entity))
		_solidity_polygons = solidity_polygons.duplicate()
		_bounding_box = bounding_box
		_revealed_sectors = revealed_sectors

func get_solidity_polygons() -> Array[PackedVector2Array]:
	return _solidity_polygons

func get_map_entities() -> Array[MapEntity]:
	return _map_entities

func get_bounding_box() -> Rect2:
	return _bounding_box

func get_revealed_sectors() -> Array[Vector2i]:
	return _revealed_sectors

func add_solidity_polygon(polygon: PackedVector2Array) -> void:
	_solidity_polygons.append(polygon)
	solidity_changed.emit()

func add_map_entity(map_entity: MapEntity) -> void:
	_map_entities.append(map_entity)
	map_entity_added.emit(map_entity)
	map_entity.source_removed.connect(remove_map_entity.bind(map_entity))

func reveal_sector(sector_coords: Vector2i) -> void:
	_revealed_sectors.append(sector_coords)
	sector_revealed.emit(sector_coords)

func map_entity_in_data(map_entity: MapEntity) -> bool:
	return _map_entities.find(map_entity) != -1

func remove_map_entity(map_entity: MapEntity) -> void:
	var index: int = _map_entities.find(map_entity)
	assert(index != -1, "map entity not in map data")
	_map_entities.remove_at(index)
	map_entity.source_removed.disconnect(remove_map_entity)
	map_entity_removed.emit(map_entity)

func set_map_entities(new_map_entities: Array[MapEntity]) -> void:
	var remove_map_entities = _map_entities.filter(func(map_entity: MapEntity) -> bool: return not new_map_entities.has(map_entity))
	
	for map_entity: MapEntity in remove_map_entities:
		remove_map_entity(map_entity)
	
	var add_map_entities = new_map_entities.filter(func(map_entity: MapEntity) -> bool: return not _map_entities.has(map_entity))
	
	for map_entity: MapEntity in add_map_entities:
		add_map_entity(map_entity)
