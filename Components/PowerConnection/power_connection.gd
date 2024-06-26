class_name PowerConnector
extends Area2D

signal just_powered
signal just_lost_power

func connect_to(connector: PowerConnector):
	PowerConnectionHandler.add_connection(self, connector)

var powered := false:
	set(new_value):
		if not powered and new_value:
			powered = new_value
			just_powered.emit()
		elif powered and not new_value:
			just_lost_power.emit()

var extra_power: float:
	get:
		if not powered:
			return false
		return extra_power
