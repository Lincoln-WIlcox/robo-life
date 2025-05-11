class_name InventoryRequirement
extends Resource

@export var batteries_cost := 0:
	set(new_value):
		assert(new_value >= 0, "batteries cost can't be negative")
		batteries_cost = new_value
@export var steel_cost := 0:
	set(new_value):
		assert(new_value >= 0, "steel cost can't be negative")
		steel_cost = new_value
@export var costs_items: Array[ItemData]
@export var requires_items: Array[ItemData]

func is_empty() -> bool:
	return batteries_cost == 0 and steel_cost == 0 and costs_items.is_empty() and requires_items.is_empty()
