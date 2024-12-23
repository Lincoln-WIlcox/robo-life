extends State

@export var none_state: State
@export var placing_state: State
@export var inventory_ui_packed_scene: PackedScene

var active_player: PlayerCharacter
var toggle_inventory: Callable

var show_ui: Callable
var hide_ui: Callable

signal inventory_opened
signal inventory_closed
signal item_dropped

var _inventory_ui

func setup_ui(player_inventory: Inventory):
	_inventory_ui = inventory_ui_packed_scene.instantiate()
	_inventory_ui.player_inventory = player_inventory
	_inventory_ui.item_dropped.connect(func(grid_item: ItemGridItem): item_dropped.emit(grid_item))

func enter():
	show_ui.call(_inventory_ui)
	inventory_opened.emit()

func run():
	if toggle_inventory.call():
		state_ended.emit(none_state)

func exit():
	hide_ui.call()
	_inventory_ui.on_gui_closed()
	inventory_closed.emit()

func on_placeable_item_dropped(grid_item: ItemGridItem):
	if is_current_state:
		placing_state.placeable_item = grid_item
		state_ended.emit(placing_state)
