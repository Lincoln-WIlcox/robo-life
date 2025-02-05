extends State

@export var map_ui_packed_scene: PackedScene
@export var none_state: State
var toggle_map: Callable
var show_ui: Callable
var hide_ui: Callable
var get_revealed_sectors: Callable
var environment_query_system: EnvironmentQuerySystem
var map_entity_collection: MapEntityCollection

var _map_ui: Map
var _map_data: MapData

func _ready():
	_map_ui = map_ui_packed_scene.instantiate()

func setup_map() -> void:
	_map_data = _get_map_data()
	map_entity_collection.map_entity_added.connect(_on_map_entity_added)
	_map_ui.display_map_data(_map_data)

func _get_map_data() -> MapData:
	var solidity_polygons: Array[PackedVector2Array] = environment_query_system.get_tile_maps_solidity()
	var bounding_box: Rect2 = environment_query_system.get_solidity_bounding_box()
	var map_data: MapData = MapData.new(map_entity_collection.get_map_entities(), solidity_polygons, bounding_box, get_revealed_sectors.call())
	return map_data

func _on_map_entity_added(added_map_entity: MapEntity) -> void:
	_map_data.add_map_entity(added_map_entity)

func enter():
	show_ui.call(_map_ui)

func run():
	if toggle_map.call():
		state_ended.emit(none_state)

func exit():
	hide_ui.call()

func _on_sector_handler_sector_revealed(sector_coords: Vector2i):
	_map_data.reveal_sector(sector_coords)
