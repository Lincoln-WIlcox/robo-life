@tool
extends State

@export var deployed_state: State
@export var retracting_state: State
@export var rope: Rope
@export var rope_growth_rate := 2
@export var max_rope_length := 80
@export var max_rope_length_tile := 5:
	set(new_value):
		max_rope_length = new_value * 16
	get:
		return int(max_rope_length / 16.0)

func run():
	if rope.height < max_rope_length:
		rope.height += rope_growth_rate
		rope.position.y = -rope.height
	else:
		rope.height = max_rope_length
		state_ended.emit(deployed_state)

func _on_power_consumer_power_requirement_lost():
	if is_current_state.call():
		state_ended.emit(retracting_state)
