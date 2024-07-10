extends State

@export var inventory_state: State

func run():
	if Input.is_action_just_pressed("toggle_inventory"):
		state_ended.emit(inventory_state)
