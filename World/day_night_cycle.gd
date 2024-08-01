class_name DayNightCycle
extends Node

@onready var day_timer = $DayTimer

signal day_ended
signal day_started

func start_new_day():
	day_timer.start()
	day_started.emit()

func _on_day_timer_timeout():
	day_ended.emit()

func get_time_left():
	return day_timer.time_left
