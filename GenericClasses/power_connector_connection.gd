class_name PowerConnectorConnection
extends RefCounted

var power_connector_a: PowerConnector
var power_connector_b: PowerConnector

func _init(_power_connector_a: PowerConnector, _power_connector_b: PowerConnector):
	power_connector_a = _power_connector_a
	power_connector_b = _power_connector_b
