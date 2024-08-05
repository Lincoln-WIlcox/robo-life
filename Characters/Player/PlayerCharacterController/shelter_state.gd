extends State

@export var none_state: State
@export var shelter_ui_packed_scene: PackedScene

var show_ui: Callable
var hide_ui: Callable
var shelter_inventory: Inventory
var inventory: Inventory
var shelter_area: ShelterInteractionArea:
	set(new_value):
		if shelter_area and shelter_area.body_exited.is_connected(_on_shelter_area_body_exited):
			shelter_area.body_exited.disconnect(_on_shelter_area_body_exited)
		shelter_area = new_value
		shelter_area.body_exited.connect(_on_shelter_area_body_exited)
var player_character: CharacterBody2D

signal shelter_opened
signal shelter_closed
signal day_ended
signal transfer_food_pressed

func enter():
	var shelter_ui = shelter_ui_packed_scene.instantiate()
	shelter_ui.shelter_inventory = shelter_inventory
	shelter_ui.player_inventory = inventory
	shelter_ui.end_day_pressed.connect(_on_end_day_pressed)
	shelter_ui.transfer_food_pressed.connect(_transfer_food)
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

func _on_shelter_area_body_exited(body: PhysicsBody2D):
	if is_current_state.call() and body == player_character:
		state_ended.emit(none_state)
