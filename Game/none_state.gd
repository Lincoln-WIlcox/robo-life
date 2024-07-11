extends State

@export var inventory_state: State
@export var pickup_stuff_handler: PickupStuffHandler

func run():
	if Input.is_action_just_pressed("toggle_inventory"):
		state_ended.emit(inventory_state)
	pickup_stuff_handler.update()
