extends Node

signal walk_over_item_collected(inventory_addition: InventoryAddition)

var inventory: Inventory

func _on_area_entered(area: Area2D):
	if area is WalkOverItemPickupArea:
		
		walk_over_item_collected.emit(area.collect())
