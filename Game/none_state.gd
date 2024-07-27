extends State

@export var inventory_state: State
@export var shelter_state: State
@export var pickup_stuff_handler: PickupStuffHandler
@export var laser_gun_handler: Node2D
@export var laser_gun: LaserGun

var toggle_inventory: Callable
var just_placed_object := false
var is_firing: Callable

func run():
	if toggle_inventory.call():
		state_ended.emit(inventory_state)
	pickup_stuff_handler.update()
	if not just_placed_object:
		laser_gun_handler.update_firing()
	if not is_firing.call():
		just_placed_object = false

func exit():
	laser_gun.firing = false

func _on_player_character_shelter_interacted_with():
	if is_current_state.call():
		state_ended.emit(shelter_state)
