class_name TimeTaskHandler
extends Node

@onready var timer = $TimeToCompletion
@onready var progress_bar = $ProgressBar

@export var task_time := 5:
	set(new_value):
		task_time = new_value
		
		if is_inside_tree():
			_set_up_progress_bar()
			timer.start(task_time)
@export var start_paused := true
@export var day_night_cycle: DayNightCycle:
	set(new_value):
		day_night_cycle = new_value
		if day_night_cycle:
			day_night_cycle.day_started.connect(_on_day_started)

var _completed := false

var _paused:
	set(new_value):
		timer.paused = new_value
	get:
		return timer.paused

signal task_completed

func _ready():
	_paused = start_paused
	reset_progress()

func get_paused() -> bool:
	return _paused

func task_complete() -> bool:
	return _completed

func make_progress() -> void:
	_paused = false
	progress_bar.show()

func pause_progress() -> void:
	_paused = true

func reset_progress() -> void:
	_completed = false
	
	_set_up_progress_bar()
	progress_bar.hide()
	
	timer.start(task_time)
	timer.paused = true
	if _paused:
		pause_progress()
	else:
		make_progress()

func _process(_delta):
	progress_bar.value = timer.time_left

func _complete_task() -> void:
	task_completed.emit()
	_completed = true

func _set_up_progress_bar() -> void:
	progress_bar.max_value = task_time
	progress_bar.value = progress_bar.max_value

func _on_day_started(_day):
	if !_paused:
		var new_start_time = timer.time_left - Utils.TIME_PASSED_AT_NIGHT
		if new_start_time > 0:
			timer.start(new_start_time)
		else:
			timer.stop()
			_complete_task()
