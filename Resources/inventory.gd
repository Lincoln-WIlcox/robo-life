class_name Inventory
extends Resource

##Used to represent the batteries, steel, and items a character or object holds.

@export var batteries := 0:
	set(new_value):
		batteries = new_value
		
		emit_changed()
@export var steel := 0:
	set(new_value):
		steel = new_value
		
		emit_changed()
##The initial value for the item grid. The item grid itself is private. To interact with it, use the functions provided.
@export var initial_item_grid: ItemGrid:
	set(new_value):
		if _item_grid == null:
			_item_grid = new_value

var _item_grid = null

##Adds an item to the item grid
func add_item(item: ItemData) -> void:
	_item_grid.add_item(item)
	emit_changed()

##Removes an item from the item grid
func remove_item(item: ItemData) -> void:
	_item_grid.remove_item(item)
	emit_changed()

##Gets all the items in the item grid
func get_items() -> Array[ItemData]:
	return _item_grid.get_items()

##Returns true if the item grid contains the given item
func has_item(item: ItemData) -> bool:
	return _item_grid.has_item(item)

##Adds an [InventoryAddition] to the inventory.
func add_addition(inventory_addition: InventoryAddition) -> void:
	batteries += inventory_addition.gain_batteries
	steel += inventory_addition.gain_steel
	for item: ItemData in inventory_addition.gain_items:
		_item_grid.add_item(item)
