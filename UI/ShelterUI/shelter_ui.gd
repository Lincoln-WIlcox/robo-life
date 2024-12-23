class_name ShelterUI
extends Control

const FOOD_TEXT = "food: "
const END_DAY_BUTTON_TEXT = "end day "

@onready var shelter_food_label = $ShelterContentVbox/ItemGridHbox/Interface1Vbox/CenterContainer/ItemGridInterface1FoodLabel
@onready var player_food_label = $ShelterContentVbox/ItemGridHbox/VBoxContainer2/CenterContainer/ItemGridInterface2FoodLabel

@export var shelter_inventory: Inventory:
	set(new_value):
		shelter_inventory = new_value
		if is_node_ready():
			$ShelterContentVbox/ItemGridHbox/Interface1Vbox/ItemGridInterface1.item_grid = shelter_inventory.item_grid
			if not shelter_inventory.changed.is_connected(update_labels):
				shelter_inventory.changed.connect(update_labels)
			if not shelter_inventory.changed.is_connected(update_end_day_disabled):
				shelter_inventory.changed.connect(update_end_day_disabled)
@export var player_inventory: Inventory:
	set(new_value):
		player_inventory = new_value
		if is_node_ready():
			$ShelterContentVbox/ItemGridHbox/VBoxContainer2/ItemGridInterface2.item_grid = player_inventory.item_grid
			if not player_inventory.changed.is_connected(update_labels):
				player_inventory.changed.connect(update_labels)
			if not player_inventory.changed.is_connected(update_end_day_disabled):
				player_inventory.changed.connect(update_end_day_disabled)

signal end_day_pressed
signal transfer_food_pressed
signal crafting_pressed

func _ready():
	$ShelterContentVbox/ItemGridHbox/Interface1Vbox/ItemGridInterface1.item_grid = shelter_inventory.item_grid
	$ShelterContentVbox/ItemGridHbox/VBoxContainer2/ItemGridInterface2.item_grid = player_inventory.item_grid
	$ShelterContentVbox/EndDayButtonMargin/EndDayHbox/EndDayButton.text = END_DAY_BUTTON_TEXT + "(" + str(Utils.AMOUNT_OF_FOOD_TO_CONSUME) + ")"
	$ShelterContentVbox/EndDayButtonMargin/EndDayHbox/EndDayButton.pressed.connect(func(): end_day_pressed.emit())
	$ShelterContentVbox/EndDayButtonMargin/EndDayHbox/TransferFoodButton.pressed.connect(func(): transfer_food_pressed.emit())
	$ShelterContentVbox/EndDayButtonMargin/EndDayHbox/CraftButton.pressed.connect(func(): crafting_pressed.emit())
	
	if not shelter_inventory.changed.is_connected(update_labels):
		shelter_inventory.changed.connect(update_labels)
	if not shelter_inventory.changed.is_connected(update_end_day_disabled):
		shelter_inventory.changed.connect(update_end_day_disabled)
	if not player_inventory.changed.is_connected(update_labels):
		player_inventory.changed.connect(update_labels)
	if not player_inventory.changed.is_connected(update_end_day_disabled):
		player_inventory.changed.connect(update_end_day_disabled)
	
	update_labels()
	update_end_day_disabled()

func open_gui() -> void:
	show()

func close_gui() -> void:
	hide()

func update_labels() -> void:
	shelter_food_label.text = FOOD_TEXT + str(shelter_inventory.get_food()) + "/" + str(shelter_inventory.max_food)
	player_food_label.text = FOOD_TEXT + str(player_inventory.get_food()) + "/" + str(player_inventory.max_food)

func update_end_day_disabled() -> void:
	$ShelterContentVbox/EndDayButtonMargin/EndDayHbox/EndDayButton.disabled = not shelter_inventory.get_food() + player_inventory.get_food() >= Utils.AMOUNT_OF_FOOD_TO_CONSUME
