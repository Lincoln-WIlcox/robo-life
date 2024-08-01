extends Control

@export var item_grid_one: ItemGrid:
	set(new_value):
		item_grid_one = new_value
		if is_node_ready():
			$VBoxContainer/TwoInventoryInterfaces.item_grid_one = item_grid_one
@export var item_grid_two: ItemGrid:
	set(new_value):
		item_grid_two = new_value
		if is_node_ready():
			$VBoxContainer/TwoInventoryInterfaces.item_grid_two = item_grid_two

signal end_day_pressed
signal transfer_food_pressed

func _ready():
	$VBoxContainer/TwoInventoryInterfaces.item_grid_one = item_grid_one
	$VBoxContainer/TwoInventoryInterfaces.item_grid_two = item_grid_two
	
	$VBoxContainer/EndDayButtonMargin/EndDayHbox/EndDayButton.pressed.connect(func(): end_day_pressed.emit())
	$VBoxContainer/EndDayButtonMargin/EndDayHbox/TransferFoodButton.pressed.connect(func(): transfer_food_pressed.emit())

func open_gui():
	show()

func close_gui():
	hide()
