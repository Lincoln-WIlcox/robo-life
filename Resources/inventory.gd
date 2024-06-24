class_name Inventory
extends Resource

@export var batteries := 0:
	set(new_value):
		batteries = new_value
		
		emit_changed()

@export var items: Array[ItemData]

func add_item(item: ItemData):
	items.append(item)
	emit_changed()

func remove_item(item: ItemData):
	items.erase(item)
	emit_changed()
