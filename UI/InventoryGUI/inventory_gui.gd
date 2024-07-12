extends Control

@onready var inventory_items_hbox = %InventoryItemsHbox

@export var inventory_gui_item_packed_scene: PackedScene

signal item_dropped(item: ItemData)

var open: bool:
	set(new_value):
		visible = new_value
	get:
		return visible

func open_gui():
	open = true

func close_gui():
	open = false

func use_inventory(inventory: Inventory):
	for inventory_gui_item: InventoryGUIItem in inventory_items_hbox.get_children():
		inventory_gui_item.queue_free()
	
	for item: ItemData in inventory.get_items():
		var inventory_gui_item: InventoryGUIItem = inventory_gui_item_packed_scene.instantiate()
		
		inventory_gui_item.item = item
		inventory_gui_item.dropped.connect(func(): item_dropped.emit(item))
		inventory_items_hbox.add_child(inventory_gui_item)
