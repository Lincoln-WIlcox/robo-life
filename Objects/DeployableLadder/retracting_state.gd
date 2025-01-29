extends State

@export var retracted_state: State
@export var deploying_state: State
@export var rope: Rope
@export var rope_shrink_rate := 2.5

func run():
	if rope.height > 0:
		rope.height -= rope_shrink_rate
		rope.position.y = -rope.height
	else:
		rope.height = 0
		state_ended.emit(retracted_state)

func _on_power_consumer_power_requirement_met():
	if is_current_state.call():
		state_ended.emit(deploying_state)
