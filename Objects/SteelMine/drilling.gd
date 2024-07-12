extends State

@onready var spawn_steel_timer: Timer = $SpawnSteelTimer

@export var time_task_handler: TimeTaskHandler

func enter():
	time_task_handler.make_progress()
	spawn_steel_timer.start()

func exit():
	time_task_handler.pause_progress()
	spawn_steel_timer.stop()

func _on_spawn_steel_timer_timeout():
	if is_current_state:
		pass
