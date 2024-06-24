extends Node2D

@onready var gain_health_interaction_area: GainHealthInteractionArea = $GainHealthInteractionArea

@export var amount := 5:
	set(new_value):
		gain_health_interaction_area.health_gain = new_value
	get:
		return gain_health_interaction_area.health_gain

func _on_gain_health_interaction_area_health_gained(interactor):
	queue_free()
