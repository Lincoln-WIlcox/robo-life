extends Node

@export var map_ui_packed_scene: PackedScene
var show_ui: Callable
var hide_ui: Callable
var environment_query_system: EnvironmentQuerySystem

var _map_ui: PowerPoleSelectionMap
var _map_data: MapData

signal power_connector_selected(power_connector: PowerConnector)

func _ready():
	_map_ui = map_ui_packed_scene.instantiate()
	_map_ui.power_pole_selected.connect(_on_map_ui_power_pole_selected)

func setup_map() -> void:
	_map_data = _get_map_data()
	environment_query_system.queryable_added.connect(_on_enviornment_query_system_queryable_added)
	_map_ui.display_map_data(_map_data)

func show_power_pole_selection_map():
	show_ui.call(_map_ui)

func _get_map_data() -> MapData:
	var solidity_polygons: Array[PackedVector2Array] = environment_query_system.get_tile_maps_solidity()
	var bounding_box: Rect2 = environment_query_system.get_solidity_bounding_box()
	var power_pole_queryables: Array[QueryableEntity] = environment_query_system.get_queryables_by_source_class(PowerPole)
	#var power_pole_queryables: Array[QueryableEntity] = environment_query_system.get_queryables_by_source_class(PowerPole.new().get_script())
	var power_pole_map_entities: Array[MapEntity]
	for power_pole_queryable: QueryableEntity in power_pole_queryables:
		var power_pole_map_entity: SelectablePowerPoleMapEntity = power_pole_queryable.source_node.make_selectable_power_pole_map_entity()
		power_pole_map_entities.append(power_pole_map_entity)
		power_pole_map_entity.selected.connect(_on_power_pole_map_entity_selected.bind(power_pole_queryable.source_node))
	var map_data: MapData = MapData.new(power_pole_map_entities, solidity_polygons, bounding_box)
	return map_data

func _on_enviornment_query_system_queryable_added(added_queryable: QueryableEntity) -> void:
	if added_queryable.source_node is PowerPole:
		_track_new_power_pole(added_queryable.source_node)

func _track_new_power_pole(power_pole: PowerPole) -> void:
	var power_pole_map_entity: SelectablePowerPoleMapEntity = power_pole.make_selectable_power_pole_map_entity()
	_map_data.add_map_entity(power_pole_map_entity)
	power_pole_map_entity.selected.connect(_on_power_pole_map_entity_selected.bind(power_pole))

func _on_power_pole_map_entity_selected(power_pole: PowerPole) -> void:
	power_connector_selected.emit(power_pole.power_connector)

func _on_map_ui_power_pole_selected(power_pole: SelectablePowerPoleMapEntity) -> void:
	_map_ui.reset_selected_power_pole()
	hide_ui.call(false)
	power_connector_selected.emit(power_pole.power_connector)
