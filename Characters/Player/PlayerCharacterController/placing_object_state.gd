extends State

@export var place_object_handler: PlayerPlaceObjectHandler
@export var none_state: State

var placeable_item: ItemGridItem
var place_object: Callable
var inventory: Inventory
var start_placing_placeable: Callable

var _placing_placeable: Placeable

func enter():
	_placing_placeable = load(placeable_item.item_data.drop_scene).instantiate()
	start_placing_placeable.call(_placing_placeable)

func end_placing() -> void:
	placeable_item = null
	state_ended.emit(none_state)

func placing_complete() -> void:
	if is_current_state.call():
		end_placing()

func placeable_placed(placed_placeable: Placeable) -> void:
	if is_current_state.call() and _placing_placeable == placed_placeable:
		inventory.remove_grid_item(placeable_item)
		end_placing()
