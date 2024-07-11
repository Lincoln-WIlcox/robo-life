extends Node

##Singleton that handles connections between power connectors and supplying/consuming power in a system.

var power_connector_connections: Array[PowerConnectorConnection]

signal connection_added(power_connection: PowerConnectorConnection)
signal connection_removed
signal connections_changed

func add_connection(connector_a: PowerConnector, connector_b: PowerConnector) -> bool:
	assert(connector_a != connector_b, "connector_a and connector_b cannot be the same power connector")
	
	for power_connector_connection: PowerConnectorConnection in power_connector_connections:
		if ((power_connector_connection.power_connector_a == connector_a 
		and power_connector_connection.power_connector_b == connector_b) or 
		(power_connector_connection.power_connector_a == connector_b
		and power_connector_connection.power_connector_b == connector_a)):
			return false
	
	var power_connector_connection: PowerConnectorConnection = PowerConnectorConnection.new(connector_a, connector_b)
	power_connector_connections.append(power_connector_connection)
	connection_added.emit(power_connector_connection)
	connections_changed.emit()
	
	_update_power_consumers_in_tree(connector_a)
	return true

func remove_connections_to_connector(connector: PowerConnector) -> void:
	for i: int in range(power_connector_connections.size()-1, -1, -1):
		if power_connector_connections[i].power_connector_a == connector or power_connector_connections[i].power_connector_b == connector:
			var other_connector = power_connector_connections[i].power_connector_a if power_connector_connections[i].power_connector_a != connector else power_connector_connections[i].power_connector_b
			#the only reason i need to store this is to i can emit it with connection removed after its been deleted
			var power_connector_at_index = power_connector_connections[i]
			power_connector_connections.remove_at(i)
			connection_removed.emit(power_connector_at_index) 
			_update_power_consumers_in_tree(other_connector)
	connections_changed.emit()

func get_power_connectors_in_tree(power_connector: PowerConnector) -> Array[PowerConnector]:
	#this is the full list of power connectors in the tree. the top level function returns this at the end of the recursive functions
	var connectors: Array[PowerConnector]
	#this is the power connector connections that include this power connector and aren't in exclude
	var connections: Array[PowerConnectorConnection] = power_connector_connections.filter(func(pc: PowerConnectorConnection): return pc.power_connector_a == power_connector or pc.power_connector_b == power_connector)
	
	connectors.append(power_connector)
	
	var exclude: Array[PowerConnectorConnection] = connections.duplicate()
	
	for connection: PowerConnectorConnection in connections:
		var child_connectors_with_exclude = _get_power_connectors_in_tree_with_excludes(connection.power_connector_a if connection.power_connector_a != power_connector else connection.power_connector_b, exclude)
		exclude.append_array(child_connectors_with_exclude["exclude"])
		connectors.append_array(child_connectors_with_exclude["connectors"])
	
	var return_array: Array[PowerConnector]
	return_array.assign(Utils.make_array_unique(connectors))
	return return_array

func _get_power_connectors_in_tree_with_excludes(power_connector: PowerConnector, exclude: Array[PowerConnectorConnection]) -> Dictionary:
	#this is the full list of power connectors in the tree. the top level function returns this at the end of the recursive functions
	var connectors: Array[PowerConnector]
	#this is the power connector connections that include this power connector and aren't in exclude
	var connections: Array[PowerConnectorConnection] = power_connector_connections.filter(
		func(pc: PowerConnectorConnection): 
			return (pc.power_connector_a == power_connector or pc.power_connector_b == power_connector) and not pc in exclude
			)
	
	connectors.append(power_connector)
	
	var new_exclude = exclude.duplicate()
	new_exclude.append_array(connections)
	
	for connection: PowerConnectorConnection in connections:
		var child_connectors_with_exclude = _get_power_connectors_in_tree_with_excludes(connection.power_connector_a if connection.power_connector_a != power_connector else connection.power_connector_b, new_exclude)
		new_exclude.append_array(child_connectors_with_exclude["exclude"])
		connectors.append_array(child_connectors_with_exclude["connectors"])
	
	return {"connectors": connectors, "exclude": new_exclude}

func _update_power_consumers_in_tree(power_connector: PowerConnector) -> void:
	var connectors: Array[PowerConnector] = get_power_connectors_in_tree(power_connector)
	var power_suppliers: Array[PowerConnector] = connectors.filter(func(connector: PowerConnector): return connector is PowerSupplier)
	var power_consumers: Array[PowerConnector] = connectors.filter(func(connector: PowerConnector): return connector is PowerConsumer)
	var total_power_supplying: int = power_suppliers.reduce(func(total_power: int, power_supplier: PowerSupplier): return total_power + power_supplier.supplies_power, 0)
	var consuming_power: int = power_consumers.reduce(func(total_power: int, power_consumer: PowerConsumer): return total_power + power_consumer.consumes_power, 0)
	
	for power_consumer: PowerConsumer in power_consumers:
		power_consumer.enough_power_supplied = total_power_supplying >= consuming_power
		power_consumer.extra_power = total_power_supplying - consuming_power / power_consumers.size() if total_power_supplying > consuming_power else 0

