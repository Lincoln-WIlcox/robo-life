extends State

@onready var spawn_steel_timer: Timer = $SpawnSteelTimer
@export var gravity_walk_over_pickup_spawner: GravityWalkOverPickupSpawner
@export var not_drilling_state: State
@export var progress_bar: ProgressBar

var is_drill_on_mine: Callable = func(): return true
var steel_remaining := 0

func enter():
	spawn_steel_timer.start()

func run():
	if not is_drill_on_mine.call():
		state_ended.emit(not_drilling_state)

func exit():
	spawn_steel_timer.stop()

func _on_spawn_steel_timer_timeout():
	if is_current_state:
		steel_remaining -= 1
		gravity_walk_over_pickup_spawner.spawn()
		progress_bar.value = progress_bar.max_value - steel_remaining
		if steel_remaining <= 0:
			state_ended.emit(not_drilling_state)

func _on_power_consumer_power_requirement_lost():
	if is_current_state:
		state_ended.emit(not_drilling_state)

func _on_time_task_handler_task_completed():
	state_ended.emit(not_drilling_state)
