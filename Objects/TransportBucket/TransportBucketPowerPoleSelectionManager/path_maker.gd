extends Node

##Uses Dijkstra's pathfinding algorithm to find the shortest path between the power connectors in the tree. Returns a PackedVector2Array of the points along the path.
##Assumes that power_connector_a and power_connector_b are in the same tree. If they aren't, the function returns null.
func make_path_points(power_connector_a: PowerConnector, power_connector_b: PowerConnector) -> Variant:
	var priority_queue: PriorityQueue = PriorityQueue.new()
	priority_queue.insert(power_connector_a, -INF)
	
	#key is a power connector, and value is its predecessor
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
				predecessors[power_connector_b] = checking_power_connector
				var vector_array: PackedVector2Array = _get_vector_array_from_predecessors(power_connector_a, power_connector_b, predecessors)
				vector_array.reverse()
				return vector_array
			
			var total_distance_from_checking_power_connector = power_connectors_total_distance[checking_power_connector] + distance_from_checking_node
			#if we've not relaxed new connector or the total distance from the checking power connector to this one is less than the existing distance, update
			if not power_connectors_total_distance.has(new_power_connector) or total_distance_from_checking_power_connector < power_connectors_total_distance[new_power_connector]:
				power_connectors_total_distance[new_power_connector] = total_distance_from_checking_power_connector
				#priority is negative because priority queue checks highest priority first, but we want to check in order of smallest distance
				priority_queue.insert(new_power_connector, -power_connectors_total_distance[new_power_connector])
				predecessors[new_power_connector] = checking_power_connector
	
	return null

func _get_vector_array_from_predecessors(power_connector_a: PowerConnector, power_connector_b: PowerConnector, predecessors: Dictionary) -> PackedVector2Array:
	var vector_array: PackedVector2Array = [power_connector_b.global_position]
	
	if power_connector_a == power_connector_b:
		return vector_array
	
	var predecessor = predecessors[power_connector_b]
	vector_array.append_array(_get_vector_array_from_predecessors(power_connector_a, predecessor, predecessors))
	return vector_array
