class_name InventoryAddition
extends Resource

@export var gain_batteries := 0:
	set(new_value):
		gain_batteries = new_value
		assert(new_value >= 0, "batteries gained can't be negative")
@export var gain_steel := 0:
	set(new_value):
		gain_steel = new_value
		assert(new_value >= 0, "steel gained can't be negative")
@export var gain_items: Array[ItemData]
