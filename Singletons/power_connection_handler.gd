extends Node

##Singleton that handles connections between power connectors and supplying/consuming power in a system.

var power_connector_connections: Array[PowerConnectorConnection]

signal connection_added(power_connection: PowerConnectorConnection)
signal connection_removed
signal connections_changed
signal connectors_state_changed

func add_connection(connector_a: PowerConnector, connector_b: PowerConnector) -> PowerConnectorConnection:
	assert(connector_a != connector_b, "connector_a and connector_b cannot be the same power connector")
	
	for power_connector_connection: PowerConnectorConnection in power_connector_connections:
		if ((power_connector_connection.power_connector_a == connector_a 
		and power_connector_connection.power_connector_b == connector_b) or 
		(power_connector_connection.power_connector_a == connector_b
		and power_connector_connection.power_connector_b == connector_a)):
			return null
	
	var power_connector_connection: PowerConnectorConnection = PowerConnectorConnection.new(connector_a, connector_b)
	power_connector_connections.append(power_connector_connection)
	connection_added.emit(power_connector_connection)
	connections_changed.emit()
	
	if not _connector_is_handled(connector_a):
		_handle_connector_added(connector_a)
	if not _connector_is_handled(connector_b):
		_handle_connector_added(connector_b)
	
	_update_power_consumers_in_tree(connector_a)
	
	connector_a.emit_connections_changed()
	connector_b.emit_connections_changed()
	
	connector_a.emit_connection_added(connector_b)
	connector_b.emit_connection_added(connector_a)
	
	return power_connector_connection

func remove_connections_to_connector(connector: PowerConnector) -> void:
	for i: int in range(power_connector_connections.size()-1, -1, -1):
		if power_connector_connections[i].power_connector_a == connector or power_connector_connections[i].power_connector_b == connector:
			var other_connector: PowerConnector = get_other_connector_in_connection(connector, power_connector_connections[i])
			#the only reason i need to store this is to i can emit it with connection removed after its been deleted
			var power_connection_at_index: PowerConnectorConnection = power_connector_connections[i]
			power_connector_connections.remove_at(i)
			connection_removed.emit(power_connection_at_index) 
			power_connection_at_index.emit_broken()
			_update_power_consumers_in_tree(other_connector)
			other_connector.emit_connections_changed()
			other_connector.emit_connection_removed(connector)
			connector.emit_connection_removed(other_connector)
	connector.emit_connections_changed()
	connections_changed.emit()

func remove_connection(connection: PowerConnectorConnection) -> void:
	power_connector_connections.erase(connection)
	connection_removed.emit(connection) 
	connection.emit_broken()
	_update_power_consumers_in_tree(connection.power_connector_a)
	_update_power_consumers_in_tree(connection.power_connector_b)
	connection.power_connector_a.emit_connections_changed()
	connection.power_connector_b.emit_connections_changed()
	connection.power_connector_a.emit_connection_removed(connection.power_connector_b)
	connection.power_connector_b.emit_connection_removed(connection.power_connector_a)

func get_connections_for_connector(power_connector: PowerConnector) -> Array[PowerConnectorConnection]:
	return power_connector_connections.filter(func(pc: PowerConnectorConnection): return pc.power_connector_a == power_connector or pc.power_connector_b == power_connector)

func get_connected_connectors_for_connector(power_connector: PowerConnector) -> Array[PowerConnector]:
	var connected_power_connections: Array[PowerConnectorConnection] = get_connections_for_connector(power_connector)
	var connected_power_connectors: Array[PowerConnector]
	
	for connected_power_connection: PowerConnectorConnection in connected_power_connections:
		var other_power_connector: PowerConnector = connected_power_connection.power_connector_a if connected_power_connection.power_connector_a != power_connector else connected_power_connection.power_connector_b
		connected_power_connectors.append(other_power_connector)
	
	return connected_power_connectors

func get_connection_count_for_power_connector(power_connector: PowerConnector) -> int:
	return power_connector_connections.reduce(func(count: int, pc: PowerConnectorConnection) -> int: return count + 1 if pc.power_connector_a == power_connector or pc.power_connector_b == power_connector else count, 0)

func get_power_connections_in_tree(power_connector: PowerConnector, exclude: Array[PowerConnectorConnection] = []) -> Array[PowerConnectorConnection]:
	
	#connections 
	var connections_for_connector: Array[PowerConnectorConnection]
	var connections_for_connector_assigner: Array = power_connector_connections.filter(
		func(pc: PowerConnectorConnection): 
			return (pc.power_connector_a == power_connector or pc.power_connector_b == power_connector) and not pc in exclude
			)
	connections_for_connector.assign(connections_for_connector_assigner)
	
	exclude.append_array(connections_for_connector)
	
	var new_power_connectors_in_connections: Array[PowerConnector]
	for power_connection: PowerConnectorConnection in connections_for_connector:
		#in each connection, either connector a or b has to be power_connector, and since each power connector is unique the other power connector will not be in two connections, so we can simply add the other power connector.
		if not power_connection.power_connector_a == power_connector:
			new_power_connectors_in_connections.append(power_connection.power_connector_a)
		else:
			new_power_connectors_in_connections.append(power_connection.power_connector_b)
	
	for check_connections_of_power_connector: PowerConnector in new_power_connectors_in_connections:
		var new_power_connections: Array[PowerConnectorConnection] = get_power_connections_in_tree(check_connections_of_power_connector, exclude)
		exclude.append_array(new_power_connections)
	
	var return_array: Array[PowerConnectorConnection] = []
	return_array.assign(Utils.make_array_unique(exclude))
	return return_array

func get_other_connector_in_connection(power_connector: PowerConnector, power_connection: PowerConnectorConnection) -> PowerConnector:
	if power_connection.power_connector_a == power_connector:
		return power_connection.power_connector_b
	elif power_connection.power_connector_b == power_connector:
		return power_connection.power_connector_a
	else:
		push_error("power_connector not in power_connection")
		return null

func get_power_connectors_in_tree(power_connector: PowerConnector, exclude: Array[PowerConnector] = []) -> Array[PowerConnector]:
	var connectors: Array[PowerConnector] = []
	var connections: Array[PowerConnectorConnection] = get_connections_for_connector(power_connector)
	
	connectors.append(power_connector)
	exclude.append(power_connector)
	
	for connection in connections:
		var other_connector: PowerConnector = get_other_connector_in_connection(power_connector, connection)
		
		if other_connector in exclude:
			continue
		
		var connected_connectors: Array[PowerConnector] = get_power_connectors_in_tree(other_connector, exclude)
		connectors.append_array(connected_connectors)
	
	return connectors

func power_connections_share_tree(power_connector_a: PowerConnector, power_connector_b: PowerConnector) -> bool:
	var power_connectors_tree: Array[PowerConnectorConnection] = get_power_connections_in_tree(power_connector_a)
	var power_connectors_in_tree: Array[PowerConnector] = _get_power_connectors_from_tree(power_connectors_tree)
	
	return power_connector_b in power_connectors_in_tree

##Returns the connection connection power_connector_a and power_connector_b. Returns null if there is none.
func get_connection_for_connectors(power_connector_a: PowerConnector, power_connector_b: PowerConnector) -> Variant:
	for connection: PowerConnectorConnection in power_connector_connections:
		if (connection.power_connector_a == power_connector_a or connection.power_connector_b == power_connector_a) and (connection.power_connector_a == power_connector_b or connection.power_connector_b == power_connector_b):
			return connection
	return null

##Uses Dijkstra's pathfinding algorithm to find the shortest path between the power connectors in the tree. Returns a PackedVector2Array of the points along the path.
##If power_connector_a and power_connector_b are not in the same tree, the function returns null.
func get_shortest_path_power_connectors(power_connector_a: PowerConnector, power_connector_b: PowerConnector) -> Variant:
	var priority_queue: PriorityQueue = PriorityQueue.new()
	priority_queue.insert(power_connector_a, -INF)
	
	#key is a power connector, and value is the connection to its predecessor
	var predecessors: Dictionary = {}
	#key is power connector, value is total distance from source
	var power_connectors_total_distance: Dictionary = {power_connector_a : 0}
	
	while not priority_queue.is_empty():
		var checking_power_connector: PowerConnector = priority_queue.extract()
		
		var connections_for_checking_connector: Array[PowerConnectorConnection] = get_connections_for_connector(checking_power_connector)
		for power_connection: PowerConnectorConnection in connections_for_checking_connector:
			#in each connection, either connector a or b has to be power_connector, and since each power connector is unique the other power connector will not be in two connections, so we can simply add the other power connector.
			var new_power_connector: PowerConnector = power_connection.power_connector_a if power_connection.power_connector_a != checking_power_connector else power_connection.power_connector_b
			
			var distance_from_checking_node: float = checking_power_connector.global_position.distance_to(new_power_connector.global_position)
			
			if new_power_connector == power_connector_b:
				predecessors[power_connector_b] = power_connection
				var shortest_path_of_power_connections: Array[PowerConnectorConnection] = _get_shortest_path_from_predecessors(power_connector_a, power_connector_b, predecessors)
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

func _get_shortest_path_from_predecessors(power_connector_a: PowerConnector, power_connector_b: PowerConnector, predecessors: Dictionary) -> Array[PowerConnectorConnection]:
	if power_connector_a == power_connector_b:
		return []
	
	var power_connection: PowerConnectorConnection = predecessors[power_connector_b]
	var shortest_power_connectors: Array[PowerConnectorConnection] = [power_connection]
	
	var other_power_connector: PowerConnector = power_connection.power_connector_a if power_connection.power_connector_a != power_connector_b else power_connection.power_connector_b
	shortest_power_connectors.append_array(_get_shortest_path_from_predecessors(power_connector_a, other_power_connector, predecessors))
	return shortest_power_connectors

func _update_power_consumers_in_tree(power_connector: PowerConnector) -> void:
	var connectors: Array[PowerConnector] = get_power_connectors_in_tree(power_connector)
	var power_suppliers: Array[PowerConnector] = connectors.filter(func(connector: PowerConnector): return connector is PowerSupplier)
	var power_consumers: Array[PowerConnector] = connectors.filter(func(connector: PowerConnector): return connector is PowerConsumer)
	var total_power_supplying: float = power_suppliers.reduce(func(total_power: int, power_supplier: PowerSupplier): return total_power + power_supplier.supplies_power, 0)
	var consuming_power: float = power_consumers.reduce(func(total_power: int, power_consumer: PowerConsumer): return total_power + (power_consumer.consumes_power if power_consumer.active else 0), 0)
	
	for updating_power_connector: PowerConnector in connectors:
		updating_power_connector.powered = total_power_supplying >= consuming_power
		if updating_power_connector is PowerConsumer:
			updating_power_connector.enough_power_supplied = total_power_supplying >= consuming_power
			updating_power_connector.extra_power = total_power_supplying - consuming_power / power_consumers.size() if total_power_supplying > consuming_power else 0.0
	
	for power_consumer: PowerConsumer in power_consumers:
		power_consumer.enough_power_supplied = total_power_supplying >= consuming_power
		power_consumer.extra_power = total_power_supplying - consuming_power / power_consumers.size() if total_power_supplying > consuming_power else 0.0
	
	connectors_state_changed.emit()

func _connector_is_handled(connector: PowerConnector) -> bool:
	return connector.status_changed.is_connected(_update_power_consumers_in_tree)

func _handle_connector_added(connector: PowerConnector) -> void:
	connector.status_changed.connect(_update_power_consumers_in_tree.bind(connector))

func _get_power_connectors_from_tree(power_connectors_tree: Array[PowerConnectorConnection]) -> Array[PowerConnector]:
	var power_connectors_in_tree: Array[PowerConnector]
	
	for power_connection_in_tree: PowerConnectorConnection in power_connectors_tree:
		power_connectors_in_tree.append(power_connection_in_tree.power_connector_a)
		power_connectors_in_tree.append(power_connection_in_tree.power_connector_b)
	
	power_connectors_in_tree = Utils.make_array_unique(power_connectors_in_tree)
	
	return power_connectors_in_tree
