extends State

@export var none_state: State
@export var shelter_ui_packed_scene: PackedScene

signal shelter_opened
signal shelter_closed

var show_ui: Callable
var hide_ui: Callable
var shelter_item_grid: ItemGrid
var inventory: Inventory

#if not active_player.inventory_opened.is_connected(inventory_gui.open_gui):
	#active_player.inventory_opened.connect(inventory_gui.open_gui)
#if not active_player.inventory_closed.is_connected(inventory_gui.close_gui):
	#active_player.inventory_closed.connect(inventory_gui.close_gui)
#if not inventory_gui.item_dropped.is_connected(active_player.handle_drop_item):
	#inventory_gui.item_dropped.connect(active_player.handle_drop_item)
#if not active_player.shelter_opened.is_connected(shelter_ui.open_gui):
	#active_player.shelter_opened.connect(shelter_ui.open_gui)
#if not active_player.shelter_closed.is_connected(shelter_ui.close_gui):
	#active_player.shelter_closed.connect(shelter_ui.close_gui)
#inventory_gui.item_grid = active_player.inventory.item_grid
#shelter_ui.item_grid_two = active_player.inventory.item_grid

func enter():
	var shelter_ui = shelter_ui_packed_scene.instantiate()
	shelter_ui.item_grid_one = shelter_item_grid
	shelter_ui.item_grid_two = inventory.item_grid
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
