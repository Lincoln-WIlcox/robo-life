extends Node

@export var interactor: Node
@export var inventory_interaction_handler: InventoryInteractionHandler

func _on_interacted_with_area(interaction_area: InteractionArea):
	if interaction_area is ItemPickup:
		inventory_interaction_handler.collect_item(interaction_area.collect_item(interactor))
