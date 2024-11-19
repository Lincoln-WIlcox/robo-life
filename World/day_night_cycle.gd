class_name DayNightCycle
extends Node

@onready var day_timer = $DayTimer

signal day_ended
signal day_started(day: int)

var _day := 0

func start_first_day() -> void:
	_day = 0
	day_timer.start()

func start_new_day() -> void:
	_day += 1
	day_timer.start()
	day_started.emit(_day)

func _on_day_timer_timeout() -> void:
	day_ended.emit()

func get_time_left() -> int:
	return day_timer.time_left

func get_day() -> int:
	return _day
