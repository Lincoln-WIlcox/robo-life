extends State

@export var inventory_gui: Control
@export var none_state: State

var get_active_player: Callable

func enter():
	inventory_gui.show()

func run():
	if Input.is_action_just_pressed("toggle_inventory"):
		state_ended.emit(none_state)

func exit():
	inventory_gui.hide()

func _on_inventory_gui_item_dropped(item: ItemData):
	get_active_player.call().drop_item(item)
