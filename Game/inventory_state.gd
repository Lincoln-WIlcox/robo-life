extends State

@export var inventory_gui: Control
@export var none_state: State
@export var placing_state: State
@export var placing_object_handler: PlaceObjectHandler

var get_active_player: Callable = func(): return PlayerCharacterController.new()

func enter():
	inventory_gui.show()

func run():
	if Input.is_action_just_pressed("toggle_inventory"):
		state_ended.emit(none_state)

func exit():
	inventory_gui.hide()

func _on_inventory_gui_item_dropped(item: ItemData):
	if item is PlaceableItemData:
		placing_object_handler.start_placing_placeable(item.drop_scene.instantiate())
		state_ended.emit(placing_state)
	else:
		get_active_player.call().drop_item(item)
