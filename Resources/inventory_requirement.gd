class_name InventoryRequirement
extends Resource

@export var batteries_cost := 0:
	set(new_value):
		batteries_cost = new_value
		assert(new_value >= 0, "batteries cost can't be negative")
@export var costs_items: Array[ItemData]
@export var requires_items: Array[ItemData]
