extends State

@export var none_state: State
@export var placing_state: State

var active_player: PlayerCharacter

signal inventory_opened
signal inventory_closed

func enter():
	inventory_opened.emit()

func run():
	if Input.is_action_just_pressed("toggle_inventory"):
		state_ended.emit(none_state)

func exit():
	inventory_closed.emit()

func on_placeable_item_dropped(item: ItemData):
	if is_current_state:
		placing_state.placeable_item = item
		state_ended.emit(placing_state)
