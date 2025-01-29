extends State

@export var retracting_state: State
@export var power_consumer: PowerConsumer

func enter():
	if not power_consumer.enough_power_supplied:
		state_ended.emit(retracting_state)

func _on_power_consumer_power_requirement_lost() -> void:
	if is_current_state.call():
		state_ended.emit(retracting_state)
