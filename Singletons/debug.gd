extends Node

signal debug_menu_toggled
signal give_battery_pressed
signal give_steel_pressed
signal give_food_pressed
signal give_drill_pressed
signal give_transport_bucket_pressed
signal give_power_pole_pressed

func _input(event):
	if OS.is_debug_build() and event.is_action_pressed("debug_menu"):
		debug_menu_toggled.emit()

func emit_give_battery_pressed() -> void:
	give_battery_pressed.emit()

func emit_give_steel_pressed() -> void:
	give_steel_pressed.emit()

func emit_give_food_pressed() -> void:
	give_food_pressed.emit()

func emit_give_drill_pressed() -> void:
	give_drill_pressed.emit()

func emit_give_transport_bucket_pressed() -> void:
	give_transport_bucket_pressed.emit()

func emit_give_power_pole_pressed() -> void:
	give_power_pole_pressed.emit()
