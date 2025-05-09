extends State

@export var inventory_requirement_interaction_area: InventoryRequirementInteractionArea
@export var power_consumer: PowerConsumer
@export var drilling_state: State

var is_drill_on_mine: Callable = func(): return false

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	if power_consumer.enough_power_supplied and drilling_state.steel_remaining > 0:
		state_ended.emit(drilling_state)

func _on_power_consumer_power_requirement_met():
	if is_drill_on_mine.call() and drilling_state.steel_remaining > 0:
		state_ended.emit(drilling_state)
