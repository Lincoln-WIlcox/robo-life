class_name InventoryInteractionHandler
extends Node

@export var inventory: Inventory

func collect_battery() -> void:
	inventory.batteries += 1

func collect_item(item: ItemData) -> bool:
	return inventory.add_item(item)

##Processes inventory requirements. If they are met, it will apply the costs to the inventory and return true. Otherwise, it will return false.
func handle_inventory_requirement(inventory_requirement: InventoryRequirement) -> bool:
	return inventory.spend_requirement(inventory_requirement)
