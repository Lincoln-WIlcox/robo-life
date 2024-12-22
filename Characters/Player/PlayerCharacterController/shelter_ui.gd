extends State

@export var none_state: State
@export var crafting_state: State
@export var shelter_ui_packed_scene: PackedScene

var show_ui: Callable
var hide_ui: Callable
var shelter_inventory: Inventory
var inventory: Inventory

signal shelter_opened
signal shelter_closed
signal day_ended

func enter():
	var shelter_ui: ShelterUI = shelter_ui_packed_scene.instantiate()
	shelter_ui.shelter_inventory = shelter_inventory
	shelter_ui.player_inventory = inventory
	shelter_ui.end_day_pressed.connect(_on_end_day_pressed)
	shelter_ui.transfer_food_pressed.connect(_transfer_food)
	shelter_ui.crafting_pressed.connect(_on_crafting_pressed)
	show_ui.call(shelter_ui)
	shelter_opened.emit()

func exit():
	hide_ui.call()
	shelter_closed.emit()

func on_shelter_closed() -> void:
	if is_current_state.call():
		state_ended.emit(none_state)

func _on_end_day_pressed() -> void:
	if shelter_inventory.get_food() + inventory.get_food() >= Utils.AMOUNT_OF_FOOD_TO_CONSUME:
		_transfer_food()
		day_ended.emit()

func _transfer_food() -> void:
	shelter_inventory.change_food(inventory.get_food())
	inventory.set_food(0)

func _on_crafting_pressed() -> void:
	if is_current_state.call():
		state_ended.emit(crafting_state)
