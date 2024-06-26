extends Node

##Singleton that handles connections between power connectors and supplying/consuming power in a system.

var power_connector_connections: Array[PowerConnectorConnection]

signal connection_added(power_connection: PowerConnectorConnection)
signal connection_removed

func add_connection(connector_a: PowerConnector, connector_b: PowerConnector):
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
	
	connector_a.tree_exited.connect(remove_connections_to_connector.bind(connector_a))
	connector_b.tree_exited.connect(remove_connections_to_connector.bind(connector_b))
	
	return true

func remove_connections_to_connector(connector: PowerConnector):
	for power_connector_connection: PowerConnectorConnection in power_connector_connections:
		if power_connector_connection.power_connector_a == connector or power_connector_connection.power_connector_b == connector:
			power_connector_connections.erase(power_connector_connection)
			connection_removed.emit(power_connector_connection)

func get_power_connectors_in_tree(power_connector: PowerConnector) -> Array[PowerConnector]:
	#this is the full list of power connectors in the tree. the top level function returns this at the end of the recursive functions
	var connectors: Array[PowerConnector]
	#this is the power connector connections that include this power connector and aren't in exclude
	var connections: Array[PowerConnectorConnection] = power_connector_connections.filter(func(pc: PowerConnectorConnection): return pc.power_connector_a == power_connector or pc.power_connector_b == power_connector)
	
	connectors.append(power_connector)
	
	var exclude = connections
	
	for connection: PowerConnectorConnection in connections:
		var child_connectors_with_exclude = _get_power_connectors_in_tree_with_excludes(connection.power_connector_a if connection.power_connector_a != power_connector else connection.power_connector_b, exclude)
		exclude.append_array(child_connectors_with_exclude["exclude"])
		connectors.append_array(child_connectors_with_exclude["connectors"])
	
	return connectors

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
	
	return {"connectors": connectors, "exclude": connections}
