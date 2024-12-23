extends State

@export var none_state: State
@export var inventory_state: State
@export var map_state: State
@export var power_pole_selection_state: State

var toggle_inventory: Callable
var toggle_map: Callable
var toggle_power_pole_selection: Callable
var get_current_ui: Callable

func enter():
	print("opened some other ui!")

func run():
	if get_current_ui.call() == null:
		state_ended.emit(none_state)
	elif toggle_inventory.call():
		state_ended.emit(inventory_state)
	elif toggle_map.call():
		state_ended.emit(map_state)
	elif toggle_power_pole_selection.call():
		state_ended.emit(power_pole_selection_state)
