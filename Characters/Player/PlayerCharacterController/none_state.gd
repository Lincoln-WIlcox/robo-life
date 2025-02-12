extends State

@export var other_state: State
@export var inventory_state: State
@export var shelter_state: State
@export var map_state: State
@export var power_pole_selection_state: State
@export var pickup_stuff_handler: PickupStuffHandler
@export var cursor_interaction_handler: MouseInteractionHandler
@export var laser_gun_handler: Node2D
@export var laser_gun: LaserGun

var toggle_inventory: Callable
var toggle_map: Callable
var toggle_power_pole_selection: Callable
var just_placed_object := false
var just_interacted_with_object := false
var is_firing: Callable
var get_current_ui: Callable

func run():
	if get_current_ui.call() != null:
		state_ended.emit(other_state)
	elif toggle_inventory.call():
		state_ended.emit(inventory_state)
	elif toggle_map.call():
		state_ended.emit(map_state)
	elif toggle_power_pole_selection and toggle_power_pole_selection.call():
		state_ended.emit(power_pole_selection_state)
	pickup_stuff_handler.update()
	cursor_interaction_handler.update()
	if not just_placed_object and not just_interacted_with_object:
		laser_gun_handler.update_firing()
	if not is_firing.call():
		just_placed_object = false
		just_interacted_with_object = false

func exit():
	laser_gun.firing = false

func _on_player_character_shelter_interacted_with(shelter_area: ShelterInteractionArea):
	if is_current_state.call():
		shelter_state.shelter_area = shelter_area
		state_ended.emit(shelter_state)

func _on_cursor_interaction_handler_interacted(_mouse_interaction_area):
	just_interacted_with_object = true
