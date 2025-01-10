class_name PowerConnector
extends Area2D

signal just_powered
signal just_lost_power
#signal connections_changed
signal status_changed

func connect_to(connector: PowerConnector) -> PowerConnectorConnection:
	return PowerConnectionHandler.add_connection(self, connector)

var powered := false:
	set(new_value):
		if not powered and new_value:
			just_powered.emit()
		elif powered and not new_value:
			just_lost_power.emit()
		powered = new_value

func _ready():
	tree_exited.connect(PowerConnectionHandler.remove_connections_to_connector.bind(self))

func emit_status_changed() -> void:
	status_changed.emit()
