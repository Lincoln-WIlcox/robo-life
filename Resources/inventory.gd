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
@export var initial_items: Array[ItemData]

var _items := initial_items

func add_item(item: ItemData) -> void:
	_items.append(item)
	emit_changed()

func remove_item(item: ItemData) -> void:
	_items.erase(item)
	emit_changed()

func get_items() -> Array[ItemData]:
	return _items

func get_item_at_index(i: int) -> ItemData:
	return _items[i]

func has_item(item: ItemData) -> bool:
	return _items.has(item)

func add_addition(inventory_addition: InventoryAddition) -> void:
	batteries += inventory_addition.gain_batteries
	steel += inventory_addition.gain_steel
	_items.append_array(inventory_addition.gain_items)
	print(steel)
