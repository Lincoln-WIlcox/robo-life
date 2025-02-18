class_name PowerConnector
extends Area2D

signal just_powered
signal just_lost_power
signal connections_changed
signal connection_added(with_connector: PowerConnector)
signal connection_removed(with_connector: PowerConnector)
signal status_changed
signal transport_bucket_arrived(transport_bucket: TransportBucket)

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

func emit_transport_bucket_arrived(transport_bucket: TransportBucket) -> void:
	transport_bucket_arrived.emit(transport_bucket)

func emit_status_changed() -> void:
	status_changed.emit()

func emit_connections_changed() -> void:
	connections_changed.emit()

func emit_connection_added(with: PowerConnector) -> void:
	connection_added.emit(with)

func emit_connection_removed(with: PowerConnector) -> void:
	connection_removed.emit(with)
