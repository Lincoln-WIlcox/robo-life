class_name Inventory
extends Resource

@export var batteries := 0:
	set(new_value):
		batteries = new_value
		
		emit_changed()
@export var steel := 0:
	set(new_value):
		steel = new_value
		
		emit_changed()
@export var initial_item_grid: ItemGrid

var _item_grid := initial_item_grid

func add_item(item: ItemData) -> void:
	_item_grid.add_item(item)
	emit_changed()

func remove_item(item: ItemData) -> void:
	_item_grid.remove_item(item)
	emit_changed()

func get_items() -> Array[ItemData]:
	return _item_grid.get_items()

func has_item(item: ItemData) -> bool:
	return _item_grid.has_item(item)

func add_addition(inventory_addition: InventoryAddition) -> void:
	batteries += inventory_addition.gain_batteries
	steel += inventory_addition.gain_steel
	for item: ItemData in inventory_addition.gain_items:
		_item_grid.add_item(item)
