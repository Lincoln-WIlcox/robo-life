class_name InventoryInteractionHandler
extends Node

@export var inventory: Inventory

func collect_battery():
	inventory.batteries += 1

func collect_item(item: ItemData):
	inventory.add_item(item)

##Processes inventory requirements. If they are met, it will apply the costs to the inventory and return true. Otherwise, it will return false.
func handle_inventory_requirement(inventory_requirement: InventoryRequirement) -> bool:
	if inventory.batteries >= inventory_requirement.batteries_cost and _check_can_spend_items(inventory_requirement) and _check_has_items(inventory_requirement):
		inventory.batteries -= inventory_requirement.batteries_cost
		for item: ItemData in inventory_requirement.costs_items:
			inventory.remove_item(item)
		return true
	else:
		return false

func _check_can_spend_items(inventory_requirement: InventoryRequirement) -> bool:
	var indexes_used: Array[int] = []
	
	#this iterates through each item in inventory_requirement.costs_items and ensures the item exists in inventory.items and hasn't been used yet.
	for item: ItemData in inventory_requirement.costs_items:
		var found_inventory_item := false
		for i: int in range(inventory.get_items().size()):
			if item == inventory.get_item_at_index(i) and not indexes_used.has(i):
				indexes_used.append(i)
				found_inventory_item = true
				break
		if !found_inventory_item:
			return false
	
	return true

func _check_has_items(inventory_requirement: InventoryRequirement) -> bool:
	return inventory_requirement.costs_items.all(func(item: ItemData): return inventory.has_item(item))
