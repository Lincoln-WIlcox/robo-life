extends State

@export var shooting_state: State

func _on_aggro_range_handler_aggro_gained():
	if is_current_state.call():
		state_ended.emit(shooting_state)
