extends Node

@export var interactor: Node
@export var inventory_interaction_handler: InventoryInteractionHandler

func _on_interacted_with_area(interaction_area: InteractionArea):
	if interaction_area is InventoryRequirementInteractionArea:
		if inventory_interaction_handler.handle_inventory_requirement(interaction_area.inventory_requirement):
			interaction_area.meet_requirements(interactor)
		else:
			interaction_area.fail_requirements(interactor)
