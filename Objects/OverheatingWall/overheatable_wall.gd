extends Node2D

func _on_overheater_max_heat_reached():
	queue_free()
