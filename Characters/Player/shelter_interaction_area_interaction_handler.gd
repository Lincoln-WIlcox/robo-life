extends Node

signal shelter_interacted_with(shelter_area: ShelterInteractionArea)

func _on_interaction_handler_interacted_with_area(interaction_area: InteractionArea):
	if interaction_area is ShelterInteractionArea:
		shelter_interacted_with.emit(interaction_area)
