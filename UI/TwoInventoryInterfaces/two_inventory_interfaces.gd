class_name TwoInventoryUI
extends Control

@onready var item_grid_interface_one: ItemGridInterface = $HBoxContainer/InteractableItemGridInterface1
@onready var item_grid_interface_two: ItemGridInterface = $HBoxContainer/InteractableItemGridInterface2

@export var item_grid_one: ItemGrid:
	set(new_value):
		item_grid_one = new_value
		if is_node_ready() and item_grid_one:
			$HBoxContainer/InteractableItemGridInterface1.item_grid = item_grid_one
@export var item_grid_two: ItemGrid:
	set(new_value):
		item_grid_two = new_value
		if is_node_ready() and item_grid_two:
			$HBoxContainer/InteractableItemGridInterface2.item_grid = item_grid_two

func _ready():
	if item_grid_one:
		item_grid_interface_one.item_grid = item_grid_one
	if item_grid_two:
		item_grid_interface_two.item_grid = item_grid_two
