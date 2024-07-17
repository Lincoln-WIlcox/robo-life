extends State

@export var inventory_state: State
@export var pickup_stuff_handler: PickupStuffHandler

var toggle_inventory: Callable

func run():
	if toggle_inventory:
		state_ended.emit(inventory_state)
	pickup_stuff_handler.update()
