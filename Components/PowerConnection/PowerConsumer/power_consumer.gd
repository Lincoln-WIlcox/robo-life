class_name PowerConsumer
extends PowerConnector

@export var consumes_power: int = 1:
	set(new_value):
		consumes_power = new_value
		status_changed.emit()
#when false, this won't consume power even if its plugged in.
@export var active := true:
	set(new_value):
		active = new_value
		status_changed.emit()

signal power_requirement_met
signal power_requirement_lost

var enough_power_supplied := false:
	set(new_value):
		if enough_power_supplied and not new_value:
			enough_power_supplied = new_value
			power_requirement_lost.emit()
		elif not enough_power_supplied and new_value:
			enough_power_supplied = new_value
			power_requirement_met.emit()
		enough_power_supplied = new_value

var extra_power: float:
	get:
		if not powered:
			return 0
		return extra_power
