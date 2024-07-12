extends State

@onready var spawn_steel_timer: Timer = $SpawnSteelTimer
@export var gravity_walk_over_pickup_spawner: GravityWalkOverPickupSpawner
@export var time_task_handler: TimeTaskHandler
@export var not_drilling_state: State

var is_drill_on_mine: Callable = func(): return true

func enter():
	time_task_handler.make_progress()
	spawn_steel_timer.start()

func run():
	if not is_drill_on_mine.call():
		state_ended.emit(not_drilling_state)

func exit():
	time_task_handler.pause_progress()
	spawn_steel_timer.stop()

func _on_spawn_steel_timer_timeout():
	if is_current_state:
		gravity_walk_over_pickup_spawner.spawn()

func _on_power_consumer_power_requirement_lost():
	if is_current_state:
		state_ended.emit(not_drilling_state)
