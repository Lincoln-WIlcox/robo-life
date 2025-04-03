class_name Terminal
extends Node2D

@export var trigger: Trigger
@export var one_time_activation: bool = false

@onready var interaction_area: InteractionArea = $InteractionArea

func _on_interaction_area_interacted_with(interactor):
	trigger.toggle()
	if one_time_activation:
		interaction_area.queue_free()
