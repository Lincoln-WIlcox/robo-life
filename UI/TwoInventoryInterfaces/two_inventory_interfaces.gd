extends Control

@onready var item_grid_interface_one: ItemGridInterface = $HBoxContainer/ItemGridInterface1
@onready var item_grid_interface_two: ItemGridInterface = $HBoxContainer/ItemGridInterface2

@export var item_grid_one: ItemGrid:
	set(new_value):
		item_grid_one = new_value
		if is_node_ready():
			$HBoxContainer/ItemGridInterface1.item_grid = item_grid_one
@export var item_grid_two: ItemGrid:
	set(new_value):
		item_grid_two = new_value
		if is_node_ready():
			$HBoxContainer/ItemGridInterface2.item_grid = item_grid_two

# Called when the node enters the scene tree for the first time.
func _ready():
	item_grid_interface_one.item_grid = item_grid_one
	item_grid_interface_two.item_grid = item_grid_two
