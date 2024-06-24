class_name GainHealthInteractionArea
extends InteractionArea

@export var health_gain := 5

signal health_gained(interactor: Object)

func gain_health(interactor: Object):
	health_gained.emit(interactor)
