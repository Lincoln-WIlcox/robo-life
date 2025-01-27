extends Node

@onready var spawn_timer := $Timer

@export var steel_spawner: GravityWalkOverPickupSpawner

var amount_to_spawn: int

signal out_of_steel

func _on_heat_receiver_started_heating():
	if amount_to_spawn > 0:
		spawn_timer.start()

func _on_heat_receiver_stopped_heating():
	spawn_timer.stop()

func _on_timer_timeout():
	if amount_to_spawn > 0:
		steel_spawner.spawn()
		amount_to_spawn -= 1
	
	if amount_to_spawn == 0:
		out_of_steel.emit()
