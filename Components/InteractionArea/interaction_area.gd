@tool
class_name InteractionArea
extends Area2D

@export var disabled := false
@export var interaction_priority := 0

signal interacted_with(interactor: Object)

func interact(interactor: Node) -> void:
	if !disabled:
		interacted_with.emit(interactor)
