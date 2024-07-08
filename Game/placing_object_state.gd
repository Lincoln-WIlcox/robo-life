extends State

@export var place_object_handler: PlaceObjectHandler
@export var none_state: State

func enter():
	pass

func run():
	place_object_handler.update_placing()
	if Input.is_action_just_pressed("place_object") and place_object_handler.attempt_place_object() or Input.is_action_just_pressed("cancel_placing_object"):
		state_ended.emit(none_state)

func exit():
	place_object_handler.stop_placing()
