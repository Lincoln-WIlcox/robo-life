class_name TransportBucketPowerPoleSelectionManager
extends Node

@onready var transport_bucket: TransportBucket = $TransportBucket
@onready var power_pole_selection_manager: Node = $PowerPoleSelectionManager

@export var environment_query_system: EnvironmentQuerySystem
@export var initial_power_connector: PowerConnector
var show_ui: Callable
var hide_ui: Callable

func setup() -> void:
	power_pole_selection_manager.show_ui = show_ui
	power_pole_selection_manager.hide_ui = hide_ui
	power_pole_selection_manager.environment_query_system = environment_query_system
	power_pole_selection_manager.setup_map()
	
	transport_bucket.global_position = initial_power_connector.global_position

func _on_placed() -> void:
	power_pole_selection_manager.show_power_pole_selection_map()

func _on_power_pole_selection_manager_power_connector_selected(power_connector: PowerConnector):
	pass # Replace with function body.
