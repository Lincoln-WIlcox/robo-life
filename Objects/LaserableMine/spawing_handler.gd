extends Node

@onready var spawn_timer := $Timer

@export var steel_spawner: GravityWalkOverPickupSpawner

func _on_heat_receiver_started_heating():
	spawn_timer.start()

func _on_heat_receiver_stopped_heating():
	spawn_timer.stop()

func _on_timer_timeout():
	steel_spawner.spawn()
