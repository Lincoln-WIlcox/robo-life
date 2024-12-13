extends Node

@export var transport_bucket: TransportBucket
var _curve: Curve2D
var _first_power_connector: PowerConnector
var _last_power_connector: PowerConnector
var _curve_power_connections: Array[PowerConnectorConnection]

##Makes a new path from power_connector_a to power_connector_b.
func make_new_path(power_connector_a: PowerConnector, power_connector_b: PowerConnector) -> void:
	_first_power_connector = power_connector_a
	_last_power_connector = power_connector_b
	
	var shortest_path_of_power_connections: Array[PowerConnectorConnection] = _get_shortest_path_power_connectors(power_connector_a, power_connector_b)
	_curve = _make_curve_from_power_connection_path(shortest_path_of_power_connections, power_connector_a)
	transport_bucket.use_curve(_curve)
	
	for power_connection: PowerConnectorConnection in _curve_power_connections:
		power_connection.broken.disconnect(_on_path_connection_broken)
	
	for power_connection: PowerConnectorConnection in shortest_path_of_power_connections:
		power_connection.broken.connect(_on_path_connection_broken.bind(power_connection))
	
	_curve_power_connections = shortest_path_of_power_connections

##Reroutes the transport bucket from its current path to a new one to the power connector. 
##Cannot be called before [method self.make_new_path], as information about the previous path is used in the calculation of the new route
func reroute_to(power_connector: PowerConnector) -> void:
	pass

##Uses Dijkstra's pathfinding algorithm to find the shortest path between the power connectors in the tree. Returns a PackedVector2Array of the points along the path.
##Assumes that power_connector_a and power_connector_b are in the same tree. If they aren't, the function returns null.
func _get_shortest_path_power_connectors(power_connector_a: PowerConnector, power_connector_b: PowerConnector) -> Variant:
	var priority_queue: PriorityQueue = PriorityQueue.new()
	priority_queue.insert(power_connector_a, -INF)
	
	#key is a power connector, and value is the connection to its predecessor
	var predecessors: Dictionary = {}
	#key is power connector, value is total distance from source
	var power_connectors_total_distance: Dictionary = {power_connector_a : 0}
	
	while not priority_queue.is_empty():
		var checking_power_connector: PowerConnector = priority_queue.extract()
		
		var connections_for_checking_connector: Array[PowerConnectorConnection] = PowerConnectionHandler.get_connections_for_connector(checking_power_connector)
		for power_connection: PowerConnectorConnection in connections_for_checking_connector:
			#in each connection, either connector a or b has to be power_connector, and since each power connector is unique the other power connector will not be in two connections, so we can simply add the other power connector.
			var new_power_connector: PowerConnector = power_connection.power_connector_a if power_connection.power_connector_a != checking_power_connector else power_connection.power_connector_b
			
			var distance_from_checking_node: float = checking_power_connector.global_position.distance_to(new_power_connector.global_position)
			
			if new_power_connector == power_connector_b:
				predecessors[power_connector_b] = power_connection
				var shortest_path_of_power_connections: Array[PowerConnectorConnection] = _get_shortest_path_of_power_connectors(power_connector_a, power_connector_b, predecessors)
				shortest_path_of_power_connections.reverse()
				return shortest_path_of_power_connections
			
			var total_distance_from_checking_power_connector = power_connectors_total_distance[checking_power_connector] + distance_from_checking_node
			#if we've not relaxed new connector or the total distance from the checking power connector to this one is less than the existing distance, update
			if not power_connectors_total_distance.has(new_power_connector) or total_distance_from_checking_power_connector < power_connectors_total_distance[new_power_connector]:
				power_connectors_total_distance[new_power_connector] = total_distance_from_checking_power_connector
				#priority is negative because priority queue checks highest priority first, but we want to check in order of smallest distance
				priority_queue.insert(new_power_connector, -power_connectors_total_distance[new_power_connector])
				predecessors[new_power_connector] = power_connection
	
	return null

func _get_shortest_path_of_power_connectors(power_connector_a: PowerConnector, power_connector_b: PowerConnector, predecessors: Dictionary) -> Array[PowerConnectorConnection]:
	if power_connector_a == power_connector_b:
		return []
	
	var power_connection: PowerConnectorConnection = predecessors[power_connector_b]
	var shortest_power_connectors: Array[PowerConnectorConnection] = [power_connection]
	
	var other_power_connector: PowerConnector = power_connection.power_connector_a if power_connection.power_connector_a != power_connector_b else power_connection.power_connector_b
	shortest_power_connectors.append_array(_get_shortest_path_of_power_connectors(power_connector_a, other_power_connector, predecessors))
	return shortest_power_connectors

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
	
	if Utils.get_offset_of_point_along_curve(_curve, point_before_connection_index) > transport_bucket.path_follow.progress:
		pass #after bucket on path
	elif Utils.get_offset_of_point_along_curve(_curve, point_before_connection_index + 1) > transport_bucket.path_follow.progress:
		transport_bucket.disconnect_from_path()
	#otherwise removal is before bucket, so it can be ignored.
	
