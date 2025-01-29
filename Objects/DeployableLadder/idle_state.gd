extends State

@export var deploying_state: State
@export var power_consumer: PowerConsumer

func enter():
	if power_consumer.enough_power_supplied:
		state_ended.emit(deploying_state)

func _on_power_consumer_power_requirement_met() -> void:
	if is_current_state.call():
		state_ended.emit(deploying_state)
