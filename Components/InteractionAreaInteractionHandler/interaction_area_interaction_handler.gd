extends Node

@export var interactor: Node

func _on_interacted_with_area(interaction_area: InteractionArea):
	interaction_area.interact(interactor)
