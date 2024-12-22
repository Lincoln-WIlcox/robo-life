extends Node

@export var path_handler: Node
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
			#don't use _track_new_power_pole cause i have to append the map entity to local array instead of script array
			var power_pole_map_entity: SelectablePowerPoleMapEntity = power_pole_queryable.source_node.make_selectable_power_pole_map_entity()
			power_pole_map_entities.append(power_pole_map_entity)
			power_pole_map_entity.selected.connect(_on_power_pole_map_entity_selected.bind(power_pole_queryable.source_node))
			power_pole_map_entity.source_removed.connect(_on_power_pole_map_entity_source_removed.bind(power_pole_map_entity))
	
	var map_data: MapData = MapData.new(power_pole_map_entities, solidity_polygons, bounding_box)
	return map_data

func _on_enviornment_query_system_queryable_added(added_queryable: QueryableEntity) -> void:
	if added_queryable.source_node is PowerPole:
		_track_new_power_pole(added_queryable.source_node)

func _track_new_power_pole(power_pole: PowerPole) -> void:
	var power_pole_map_entity: SelectablePowerPoleMapEntity = power_pole.make_selectable_power_pole_map_entity()
	_map_data.add_map_entity(power_pole_map_entity)
	power_pole_map_entity.selected.connect(_on_power_pole_map_entity_selected.bind(power_pole))
	power_pole_map_entity.source_removed.connect(_on_power_pole_map_entity_source_removed.bind(power_pole_map_entity))

func _on_power_pole_map_entity_selected(power_pole: PowerPole) -> void:
	power_connector_selected.emit(power_pole.power_connector)

func _on_map_ui_power_pole_selected(power_pole: SelectablePowerPoleMapEntity) -> void:
	power_connector_selected.emit(power_pole.power_connector)

func _on_power_pole_map_entity_source_removed(removed_map_entity: SelectablePowerPoleMapEntity) -> void:
	var using_power_connector: PowerConnector
	if path_handler.path_is_made():
		using_power_connector = path_handler.get_last_power_connector()
	else: 
		using_power_connector = initial_power_connector
	
	PowerConnectionHandler.remove_connections_to_connector(removed_map_entity.source_node.power_connector)
	var power_connectors_in_tree = PowerConnectionHandler.get_power_connectors_in_tree(using_power_connector)
	
	var iterating_map_entities: Array[MapEntity] = _map_data.get_map_entities().filter(func(map_entity: MapEntity): return map_entity is SelectablePowerPoleMapEntity).duplicate()
	for map_entity: SelectablePowerPoleMapEntity in iterating_map_entities:
		#excluding the removing map entity since it needs to remove itself
		if not map_entity.source_node.power_connector in power_connectors_in_tree and map_entity != removed_map_entity:
			_map_data.remove_map_entity(map_entity)
