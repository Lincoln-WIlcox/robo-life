extends State

@export var none_state: State
@export var shelter_ui_packed_scene: PackedScene

var show_ui: Callable
var hide_ui: Callable
var shelter_item_grid: ItemGrid
var inventory: Inventory

signal shelter_opened
signal shelter_closed
signal end_day_pressed

func enter():
	var shelter_ui = shelter_ui_packed_scene.instantiate()
	shelter_ui.item_grid_one = shelter_item_grid
	shelter_ui.item_grid_two = inventory.item_grid
	shelter_ui.end_day_pressed.connect(func(): end_day_pressed.emit())
	show_ui.call(shelter_ui)
	shelter_opened.emit()

func run():
	pass

func exit():
	hide_ui.call()
	shelter_closed.emit()

func on_shelter_closed():
	if is_current_state.call():
		state_ended.emit(none_state)
