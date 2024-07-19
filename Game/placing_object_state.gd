extends State

@export var place_object_handler: PlaceObjectHandler
@export var none_state: State

var placeable_item: PlaceableItemData
var place_object: Callable
var cancel_placing_object: Callable
var inventory: Inventory

func enter():
	place_object_handler.start_placing_placeable(load(placeable_item.drop_scene).instantiate())

func run():
	place_object_handler.update_placing()
	if place_object.call() and place_object_handler.attempt_place_object():
		inventory.remove_item(placeable_item)
		none_state.just_placed_object = true
		state_ended.emit(none_state)
	if cancel_placing_object.call():
		place_object_handler.cancel_placing()
		state_ended.emit(none_state)

func exit():
	place_object_handler.stop_placing()
