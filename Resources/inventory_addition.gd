class_name InventoryAddition
extends Resource

##Represents values to add to an inventory. Passed to [method Inventory.add_addition]. The variables are subtracted from the inventory addition as they are put into an inventory

##Emitted when all values have reached zero
signal reached_zero

##Number of batteries gained
@export var use_exported_properties := false
@export var gain_batteries := 0:
	set(new_value):
		gain_batteries = new_value
		assert(new_value >= 0, "batteries gained can't be negative")
		if check_reached_zero():
			reached_zero.emit()
		emit_changed()
##Number of steel gained
@export var gain_steel := 0:
	set(new_value):
		gain_steel = new_value
		assert(new_value >= 0, "steel gained can't be negative")
		if check_reached_zero():
			reached_zero.emit()
		emit_changed()
##Amount of food gained
@export var gain_food := 0:
	set(new_value):
		gain_food = new_value
		assert(new_value >= 0, "food gained can't be negative")
		if check_reached_zero():
			reached_zero.emit()
		emit_changed()
##Items gained
@export var initial_gain_items: Array[ItemData]:
	set(new_value):
		if not _gain_items:
			initial_gain_items = new_value
			_gain_items = initial_gain_items
			emit_changed()
		else:
			push_warning("changing initial_gain_items after initialization does nothing")

#interface for private variable so you have to use the methods to interact with it so it can check if its reached zero whenever you interact with it.
var _gain_items: Array[ItemData]

func _init(init_gain_batteries: int = 0, init_gain_steel: int = 0, init_gain_food: int = 0, init_gain_items: Array[ItemData] = []):
	if !use_exported_properties:
		gain_batteries = init_gain_batteries
		gain_steel = init_gain_steel
		gain_food = init_gain_food
		_gain_items = init_gain_items.duplicate()

##Returns true if all values are 0
func check_reached_zero() -> bool:
	return gain_batteries == 0 and gain_steel == 0 and gain_food == 0 and _gain_items.size() == 0

##Removes all items
func remove_all_items() -> void:
	_gain_items = []
	if check_reached_zero():
		reached_zero.emit()

##Removes one item using [method Array.erase]
func remove_item(item: ItemData) -> void:
	_gain_items.erase(item)
	if check_reached_zero():
		reached_zero.emit()

##Returns gain items.
func get_gain_items() -> Array[ItemData]:
	return _gain_items

func add_item(item: ItemData) -> void:
	_gain_items.append(item)
