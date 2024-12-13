extends Node

@export var map_ui_packed_scene: PackedScene
var environment_query_system: EnvironmentQuerySystem
var initial_power_connector: PowerConnector

var _map_data: MapData

signal power_connector_selected(power_connector: PowerConnector)

func setup_map(map: TransportBucketUI) -> void:
	_map_data = _get_map_data()
	environment_query_system.queryable_added.connect(_on_enviornment_query_system_queryable_added)
	map.setup(_map_data)

func _get_map_data() -> MapData:
	var solidity_polygons: Array[PackedVector2Array] = environment_query_system.get_tile_maps_solidity()
	var bounding_box: Rect2 = environment_query_system.get_solidity_bounding_box()
	var power_pole_queryables: Array[QueryableEntity] = environment_query_system.get_queryables_by_source_class(PowerPole)
	var power_pole_map_entities: Array[MapEntity]
	
	var power_connectors_in_tree: Array[PowerConnector] = PowerConnectionHandler.get_power_connectors_in_tree(initial_power_connector)
	
	for power_pole_queryable: QueryableEntity in power_pole_queryables:
		if power_pole_queryable.source_node.power_connector in power_connectors_in_tree:
			var power_pole_map_entity: SelectablePowerPoleMapEntity = power_pole_queryable.source_node.make_selectable_power_pole_map_entity()
			power_pole_map_entities.append(power_pole_map_entity)
			power_pole_map_entity.selected.connect(_on_power_pole_map_entity_selected.bind(power_pole_queryable.source_node))
			power_pole_map_entity.source_removed.connect(_on_power_pole_map_entity_source_removed)
	
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
	power_connector_selected.emit(power_pole.power_connector)

func _on_power_pole_map_entity_source_removed() -> void:
	pass
