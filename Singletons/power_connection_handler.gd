extends Node

##Singleton that handles connections between power connectors and supplying/consuming power in a system.

var power_connector_connections: Array[PowerConnectorConnection]

func add_connection(connector_a: PowerConnector, connector_b: PowerConnector):
	assert(connector_a != connector_b, "connector_a and connector_b cannot be the same power connector")
	
	for power_connector_connection: PowerConnectorConnection in power_connector_connections:
		if power_connector_connection.power_connector_a == connector_a and power_connector_connection.power_connector_b == connector_b:
			return false
	
	var power_connector_connection: PowerConnectorConnection = PowerConnectorConnection.new(connector_a, connector_b)
	power_connector_connections.append(power_connector_connection)
