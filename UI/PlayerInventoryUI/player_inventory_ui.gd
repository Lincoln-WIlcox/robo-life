extends Control

const FOOD_LABEL_TEXT := "food: "

@onready var item_grid_interface = $VBoxContainer/ItemGridInterface
@onready var label = $VBoxContainer/CenterContainer/Label

@export var player_inventory: Inventory:
	set(new_value):
		player_inventory = new_value
		if is_node_ready():
			update_children()

signal item_dropped(grid_item: ItemGridItem)

func _ready():
	item_grid_interface.item_dropped.connect(func(grid_item: ItemGridItem): item_dropped.emit(grid_item))
	player_inventory.changed.connect(update_children)
	update_children()

func update_children() -> void:
	item_grid_interface.item_grid = player_inventory.item_grid
	label.text = FOOD_LABEL_TEXT + str(player_inventory.get_food()) + "/" + str(player_inventory.max_food)

func on_gui_closed() -> void:
	item_grid_interface.close_gui()

func _on_tree_entered() -> void:
	if is_node_ready():
		item_grid_interface.update_grid()
