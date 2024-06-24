extends Node2D

signal interacted_with

func _on_interaction_area_interacted_with(interactor):
	interacted_with.emit()
