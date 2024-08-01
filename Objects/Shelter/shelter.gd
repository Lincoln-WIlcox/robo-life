extends Node2D

signal interacted_with

func _on_interaction_area_interacted_with(interactor: Node):
	if interactor is PlayerCharacter:
		print("wowzers!")
