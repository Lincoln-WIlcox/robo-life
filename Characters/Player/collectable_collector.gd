extends Node

signal battery_collected

func _on_area_entered(area: Area2D):
	if area is BatteryPickup:
		battery_collected.emit()
		area.queue_free()
