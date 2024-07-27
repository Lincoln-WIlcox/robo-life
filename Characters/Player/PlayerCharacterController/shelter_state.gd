extends State

@export var none_state: State

signal shelter_opened
signal shelter_closed

func enter():
	shelter_opened.emit()

func run():
	pass

func exit():
	shelter_closed.emit()

func on_shelter_closed():
	if is_current_state.call():
		state_ended.emit(none_state)
