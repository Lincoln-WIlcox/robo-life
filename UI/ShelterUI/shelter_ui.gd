class_name ShelterUI
extends Control

const FOOD_TEXT = "food: "
const END_DAY_BUTTON_TEXT = "end day "

@export var shelter_inventory: Inventory:
	set(new_value):
		shelter_inventory = new_value
		if is_node_ready():
			$ShelterContentVbox/ItemGridHbox/Interface1Vbox/InteractableItemGridInterface1.item_grid = shelter_inventory.item_grid
			if not shelter_inventory.changed.is_connected(update_end_day_disabled):
				shelter_inventory.changed.connect(update_end_day_disabled)
@export var player_inventory: Inventory:
	set(new_value):
		player_inventory = new_value
		if is_node_ready():
			$ShelterContentVbox/ItemGridHbox/VBoxContainer2/InteractableItemGridInterface2.item_grid = player_inventory.item_grid
			if not player_inventory.changed.is_connected(update_end_day_disabled):
				player_inventory.changed.connect(update_end_day_disabled)

@onready var battery_transfer: CounterTransferUI = $ShelterContentVbox/MarginContainer/ItemGridHbox/CountersCenterContainer/CounterTransfersVbox/BatteryTransfer
@onready var steel_transfer: CounterTransferUI = $ShelterContentVbox/MarginContainer/ItemGridHbox/CountersCenterContainer/CounterTransfersVbox/SteelTransfer
@onready var food_transfer: CounterTransferUI = $ShelterContentVbox/MarginContainer/ItemGridHbox/CountersCenterContainer/CounterTransfersVbox/FoodTransfer
@onready var item_grid_interface_1: ItemGridInterface = $ShelterContentVbox/MarginContainer/ItemGridHbox/Interface1Vbox/InteractableItemGridInterface1
@onready var item_grid_interface_2: ItemGridInterface = $ShelterContentVbox/MarginContainer/ItemGridHbox/Interface2Vbox/InteractableItemGridInterface2
@onready var end_day_button: Button = $ShelterContentVbox/EndDayButtonMargin/EndDayHbox/EndDayButton
@onready var craft_button: Button = $ShelterContentVbox/EndDayButtonMargin/EndDayHbox/CraftButton

signal end_day_pressed
signal transfer_food_pressed
signal crafting_pressed
signal warp_pressed

func _ready():
	item_grid_interface_1.item_grid = shelter_inventory.item_grid
	item_grid_interface_2.item_grid = player_inventory.item_grid
	end_day_button.text = END_DAY_BUTTON_TEXT + "(" + str(Utils.AMOUNT_OF_FOOD_TO_CONSUME) + ")"
	end_day_button.pressed.connect(func(): end_day_pressed.emit())
	craft_button.pressed.connect(func(): crafting_pressed.emit())
	
	if not shelter_inventory.changed.is_connected(update_end_day_disabled):
		shelter_inventory.changed.connect(update_end_day_disabled)
	if not player_inventory.changed.is_connected(update_end_day_disabled):
		player_inventory.changed.connect(update_end_day_disabled)
	
	battery_transfer.counter_1 = shelter_inventory.batteries
	battery_transfer.counter_2 = player_inventory.batteries
	steel_transfer.counter_1 = shelter_inventory.steel
	steel_transfer.counter_2 = player_inventory.steel
	food_transfer.counter_1 = shelter_inventory.food
	food_transfer.counter_2 = player_inventory.food
	
	update_end_day_disabled()

func open_gui() -> void:
	show()

func close_gui() -> void:
	hide()

func update_end_day_disabled() -> void:
	end_day_button.disabled = not shelter_inventory.food.value + player_inventory.food.value >= Utils.AMOUNT_OF_FOOD_TO_CONSUME

func _on_warp_button_pressed():
	warp_pressed.emit()
