extends Node

func make_path(power_connector_a: PowerConnector, power_connector_b: PowerConnector) -> void:
	var power_connectors_tree: Array[PowerConnectorConnection] = PowerConnectionHandler.get_power_connections_in_tree(power_connector_a)
