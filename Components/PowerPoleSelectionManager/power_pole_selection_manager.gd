class_name PowerPoleSelectionManager
extends Node

@export var ui_state_machine: StateMachine
@export var power_pole_selection_map_state: State
@export var enviornment_query_system: EnvironmentQuerySystem

signal power_pole_selected

func start_selecting_power_pole() -> void:
	ui_state_machine.set_state(power_pole_selection_map_state)
