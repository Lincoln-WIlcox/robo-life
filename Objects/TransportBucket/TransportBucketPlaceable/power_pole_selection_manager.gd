extends Node

@export var path_handler: Node
var environment_query_system: EnvironmentQuerySystem
var initial_power_connector: PowerConnector
var get_revealed_sectors: Callable

var _map_data: MapData
var _tracking_power_connectors: Array[PowerConnector]

signal power_connector_selected(power_connector: PowerConnector)

func setup_map(map: TransportBucketUI) -> void:
	_map_data = _get_map_data()
	#environment_query_system.queryable_added.connect(_on_enviornment_query_system_queryable_added)
	map.setup(_map_data)

func reveal_sector(sector_coords: Vector2i) -> void:
	if _map_data:
		_map_data.reveal_sector(sector_coords)

func _get_map_data() -> MapData:
	var solidity_polygons: Array[PackedVector2Array] = environment_query_system.get_tile_maps_solidity()
	var bounding_box: Rect2 = environment_query_system.get_solidity_bounding_box()
	var destination_queryables_assigner: Array[QueryableEntity] = environment_query_system.get_queryables_by_class(TransportBucketDestinationSelectionQueryableEntity)
	var destination_queryables: Array[TransportBucketDestinationSelectionQueryableEntity]
	destination_queryables.assign(destination_queryables_assigner)
	
	var destination_map_entities: Array[MapEntity]
	
	var using_power_connector = _get_using_power_connector()
	var power_connectors_in_tree: Array[PowerConnector] = PowerConnectionHandler.get_power_connectors_in_tree(using_power_connector)
	
	for destination_queryable: TransportBucketDestinationSelectionQueryableEntity in destination_queryables:
		if destination_queryable.power_connector in power_connectors_in_tree:
			#don't use _track_new_power_pole cause i have to append the map entity to local array instead of script array
			var destination_map_entity: SelectableMapEntity = destination_queryable.make_selectable_map_entity()
			destination_map_entities.append(destination_map_entity)
			_register_queryable(destination_queryable, destination_map_entity)
	
	var map_data: MapData = MapData.new(destination_map_entities, solidity_polygons, bounding_box, get_revealed_sectors.call())
	return map_data

func update_map_data() -> void:
	var destination_queryables_assigner: Array[QueryableEntity] = environment_query_system.get_queryables_by_class(TransportBucketDestinationSelectionQueryableEntity)
	var destination_queryables: Array[TransportBucketDestinationSelectionQueryableEntity]
	destination_queryables.assign(destination_queryables_assigner)
	
	var using_power_connector = _get_using_power_connector()
	var power_connectors_in_tree: Array[PowerConnector] = PowerConnectionHandler.get_power_connectors_in_tree(using_power_connector)
	
	var using_queryables: Array[TransportBucketDestinationSelectionQueryableEntity] = destination_queryables.filter(func(queryable: TransportBucketDestinationSelectionQueryableEntity) -> bool: return power_connectors_in_tree.has(queryable.power_connector)) 
	var new_map_entities: Array[MapEntity]
	
	for queryable: TransportBucketDestinationSelectionQueryableEntity in using_queryables:
		var destination_map_entity: SelectableMapEntity = queryable.make_selectable_map_entity()
		_register_queryable(queryable, destination_map_entity)
		new_map_entities.append(destination_map_entity)
	
	_map_data.set_map_entities(new_map_entities)

func _register_queryable(queryable: TransportBucketDestinationSelectionQueryableEntity, map_entity: SelectableMapEntity) -> void:
	if not map_entity.selected.is_connected(_on_destination_map_entity_selected):
		map_entity.selected.connect(_on_destination_map_entity_selected.bind(queryable))
	if not queryable.power_connector.connections_changed.is_connected(update_map_data.call_deferred):
		queryable.power_connector.connections_changed.connect(update_map_data.call_deferred)
	if not _tracking_power_connectors.has(queryable.power_connector):
		_tracking_power_connectors.append(queryable.power_connector)

#func _on_enviornment_query_system_queryable_added(added_queryable: QueryableEntity) -> void:
	#if added_queryable.source_node is PowerPole:
		#_track_new_destination(added_queryable)
#
#func _track_new_destination(destination_queryable: TransportBucketDestinationSelectionQueryableEntity) -> void:
	#var destination_map_entity: SelectableMapEntity = destination_queryable.make_selectable_map_entity()
	#_map_data.add_map_entity(destination_map_entity)
	#destination_map_entity.selected.connect(_on_destination_map_entity_selected.bind(destination_queryable))
	#destination_queryable.power_connector.connections_changed.connect(_get_map_data)

func _on_destination_map_entity_selected(destination_queryable: TransportBucketDestinationSelectionQueryableEntity) -> void:
	power_connector_selected.emit(destination_queryable.power_connector)

#???
func _on_map_ui_power_pole_selected(destination_queryable: SelectableMapEntity) -> void:
	power_connector_selected.emit(destination_queryable.power_connector)

func _get_using_power_connector() -> PowerConnector:
	var using_power_connector: PowerConnector
	if path_handler.path_is_made():
		using_power_connector = path_handler.get_previous_power_connector()
	else:
		using_power_connector = initial_power_connector
	return using_power_connector
