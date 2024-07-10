class_name PowerConnector
extends Area2D

signal just_powered
signal just_lost_power
signal connections_changed

func connect_to(connector: PowerConnector):
	PowerConnectionHandler.add_connection(self, connector)

var powered := false:
	set(new_value):
		if not powered and new_value:
			just_powered.emit()
		elif powered and not new_value:
			just_lost_power.emit()
		powered = new_value
