extends State

@export var none_state: State
@export var placing_state: State

var active_player: PlayerCharacter
var toggle_inventory: Callable

signal inventory_opened
signal inventory_closed

func enter():
	inventory_opened.emit()

func run():
	if toggle_inventory.call():
		state_ended.emit(none_state)

func exit():
	inventory_closed.emit()

func on_placeable_item_dropped(item: ItemData):
	if is_current_state:
		placing_state.placeable_item = item
		state_ended.emit(placing_state)
