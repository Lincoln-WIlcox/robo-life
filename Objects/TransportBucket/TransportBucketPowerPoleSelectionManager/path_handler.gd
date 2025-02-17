extends Node

@export var transport_bucket: TransportBucket
var _curve: Curve2D
var _first_power_connector: PowerConnector
var _last_power_connector: PowerConnector
var _curve_power_connections: Array[PowerConnectorConnection]
var _curve_power_connectors: Array[PowerConnector]

##Makes a new path from power_connector_a to power_connector_b. Transport bucket will be immediately moved to power_connector_a.
func make_new_path(power_connector_a: PowerConnector, power_connector_b: PowerConnector) -> void:
	_first_power_connector = power_connector_a
	_last_power_connector = power_connector_b
	
	_update_curve_to_power_connectors(_first_power_connector, _last_power_connector)
	var shortest_path_of_power_connections: Array[PowerConnectorConnection] = PowerConnectionHandler.get_shortest_path_power_connectors(power_connector_a, power_connector_b)
	var shortest_path_curve: Curve2D = _make_curve_from_power_connection_path(shortest_path_of_power_connections, power_connector_a)
	transport_bucket.use_curve(shortest_path_curve)
	
	_curve = shortest_path_curve
	_update_power_connectors(shortest_path_of_power_connections, power_connector_a)

func get_previous_power_connector() -> PowerConnector:
	var previous_connector_index: int = Utils.get_index_of_point_along_curve_before_offset(_curve, transport_bucket.path_follow.progress)
	return _curve_power_connectors[previous_connector_index]

##Reroutes from the transport bucket's current position.
##Cannot be called before [method self.make_new_path], as information about the previous path is used in the calculation of the new route
func reroute() -> void:
	assert(_curve != null, "reroute_to was called before path was made")
	
	#previous is the connector that transport bucket has just passed
	var previous_connector_index: int = Utils.get_index_of_point_along_curve_before_offset(_curve, transport_bucket.path_follow.progress)
	
	#if transport bucket is at the end of the path, use the power connector the transport bucket is on
	if previous_connector_index == _curve_power_connectors.size() - 1:
		var using_power_connector: PowerConnector = _curve_power_connectors.back()
		_update_curve_to_power_connectors(using_power_connector, _last_power_connector)
		return
	
	#getting connectors transport bucket is between
	var previous_connector: PowerConnector = _curve_power_connectors[previous_connector_index]
	var next_connector: PowerConnector = _curve_power_connectors[previous_connector_index + 1]
	
	#getting path from both connectors
	var path_of_connectors_from_previous_connector_or_no_path: Variant = PowerConnectionHandler.get_shortest_path_power_connectors(previous_connector, _last_power_connector)
	var path_of_connectors_from_next_connector_or_no_path: Variant = PowerConnectionHandler.get_shortest_path_power_connectors(next_connector, _last_power_connector)
	
	#if the path is null, that means the target power connector is no longer connected to the transport bucket, so it stops.
	if path_of_connectors_from_previous_connector_or_no_path == null and path_of_connectors_from_next_connector_or_no_path == null:
		transport_bucket.stop()
		return
	
	var path_of_connectors_from_previous_connector: Array[PowerConnectorConnection] = path_of_connectors_from_previous_connector_or_no_path
	var path_of_connectors_from_next_connector: Array[PowerConnectorConnection] = path_of_connectors_from_next_connector_or_no_path
	
	var curve_from_previous_connector: Curve2D = _make_curve_from_power_connection_path(path_of_connectors_from_previous_connector, previous_connector)
	var curve_from_next_connector: Curve2D = _make_curve_from_power_connection_path(path_of_connectors_from_next_connector, next_connector)
	
	#depending on which path is shorter, it will set these variables accordingly
	var shortest_path_curve: Curve2D
	var shortest_connections_path: Array[PowerConnectorConnection]
	var shortest_connector: PowerConnector
	
	var distance_from_previous: float = transport_bucket.path_follow.global_position.distance_to(previous_connector.global_position)
	var distance_from_next: float = transport_bucket.path_follow.global_position.distance_to(next_connector.global_position)
	if curve_from_previous_connector.get_baked_length() + distance_from_previous < curve_from_next_connector.get_baked_length() + distance_from_next:
		shortest_path_curve = curve_from_previous_connector
		shortest_connector = previous_connector
		shortest_connections_path = path_of_connectors_from_previous_connector
	else:
		shortest_path_curve = curve_from_next_connector
		shortest_connector = next_connector
		shortest_connections_path = path_of_connectors_from_next_connector
	
	shortest_path_curve.add_point(transport_bucket.path_follow.global_position, Vector2.ZERO, Vector2.ZERO, 0)
	transport_bucket.use_curve(shortest_path_curve)
	transport_bucket.path_follow.progress = 0
	
	_curve = shortest_path_curve
	_first_power_connector = shortest_connector
	shortest_connections_path.push_front(PowerConnectionHandler.get_connection_for_connectors(previous_connector, next_connector))
	_update_power_connectors(shortest_connections_path, shortest_connector)

##Reroutes to given target connector from the transport bucket's position.
##Cannot be called before [method self.make_new_path], as information about the previous path is used in the calculation of the new route
func reroute_to(target_connector: PowerConnector) -> void:
	_last_power_connector = target_connector
	reroute()

func path_is_made() -> bool:
	return _curve != null

##Returns the power connector the transport bucket last passed. Returns null if path has not been set up.
##Check path_is_made to ensure there is a path first.
func get_last_power_connector() -> PowerConnector:
	return _last_power_connector

func _update_curve_to_power_connectors(power_connector_a: PowerConnector, power_connector_b: PowerConnector) -> void:
	var shortest_path_of_power_connections: Array[PowerConnectorConnection] = PowerConnectionHandler.get_shortest_path_power_connectors(power_connector_a, power_connector_b)
	var shortest_path_curve: Curve2D = _make_curve_from_power_connection_path(shortest_path_of_power_connections, power_connector_a)
	transport_bucket.use_curve(shortest_path_curve)
	
	_first_power_connector = power_connector_a
	_last_power_connector = power_connector_b
	_curve = shortest_path_curve
	_update_power_connectors(shortest_path_of_power_connections, power_connector_a)

func _update_power_connectors(power_connections_path: Array[PowerConnectorConnection], starting_power_connector: PowerConnector) -> void:
	for power_connection: PowerConnectorConnection in _curve_power_connections:
		power_connection.broken.disconnect(_on_path_connection_broken)
	
	_curve_power_connectors = [starting_power_connector]
	
	for power_connection: PowerConnectorConnection in power_connections_path:
		power_connection.broken.connect(_on_path_connection_broken.bind(power_connection))
		_curve_power_connectors.append(power_connection.power_connector_a if power_connection.power_connector_a not in _curve_power_connectors else power_connection.power_connector_b)
	
	_curve_power_connections = power_connections_path

func _make_curve_from_power_connection_path(power_connection_path: Array[PowerConnectorConnection], starting_power_connector: PowerConnector) -> Curve2D:
	var curve: Curve2D = Curve2D.new()
	
	curve.add_point(starting_power_connector.global_position)
	
	var last_checked_power_connector: PowerConnector = starting_power_connector
	for i: int in range(power_connection_path.size()):
		var new_power_connector = power_connection_path[i].power_connector_a if power_connection_path[i].power_connector_a != last_checked_power_connector else power_connection_path[i].power_connector_b
		curve.add_point(new_power_connector.global_position)
		last_checked_power_connector = new_power_connector
	
	return curve

func _on_path_connection_broken(connection: PowerConnectorConnection) -> void:
	var point_before_connection_index: int = _curve_power_connections.find(connection)
	
	if Utils.get_offset_of_point_along_curve(_curve, point_before_connection_index) > transport_bucket.path_follow.progress: #connection ahead of bucket broken
		reroute()
	elif Utils.get_offset_of_point_along_curve(_curve, point_before_connection_index + 1) > transport_bucket.path_follow.progress: #connection bucket is on broken
		transport_bucket.disconnect_from_path()
	#otherwise removal is before bucket, so it can be ignored.
