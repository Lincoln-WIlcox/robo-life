class_name MouseInteractionArea
extends Area2D

@export var pickup_priority: int = 0

@onready var out_of_range_text_spawner: FloatAwayTextSpawner = $OutOfRangeTextSpawner

signal interacted_with

func interact() -> void:
	interacted_with.emit()

func interaction_out_of_range() -> void:
	out_of_range_text_spawner.spawn_text()
