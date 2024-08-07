extends State

@export var none_state: State

@onready var state_machine: StateMachine = $ShelterStateMachine
@onready var shelter_ui_state = $ShelterStateMachine/Shelter
@onready var shelter_none_state = $ShelterStateMachine/None

var interaction_area: Area2D:
	set(new_value):
		if new_value:
			interaction_area = new_value
			interaction_area.area_exited.connect(_on_interaction_area_area_exited)
var shelter_area: ShelterInteractionArea:
	set(new_value):
		shelter_area = new_value

func enter():
	state_machine.set_state(shelter_ui_state)

func exit():
	state_machine.set_state(shelter_none_state)

func on_shelter_closed() -> void:
	if is_current_state.call():
		state_ended.emit(none_state)

func _on_interaction_area_area_exited(area: Area2D):
	if is_current_state.call() and area == shelter_area:
		state_ended.emit(none_state)
