class_name TransportBucketPowerPoleSelectionManager
extends Node

@onready var transport_bucket: TransportBucket = $TransportBucket
@onready var power_pole_selection_manager: Node = $PowerPoleSelectionManager

@export var environment_query_system: EnvironmentQuerySystem
@export var initial_power_connector: PowerConnector
@export var transport_bucket_ui_packed_scene: PackedScene

var show_ui: Callable
var hide_ui: Callable

var _ui: TransportBucketUI

func setup() -> void:
	_ui = transport_bucket_ui_packed_scene.instantiate()
	_ui.player_inventory = Inventory.new()
	_ui.transport_bucket_inventory = transport_bucket.get_inventory()
	_ui.closed.connect(_on_ui_closed)
	
	power_pole_selection_manager.environment_query_system = environment_query_system
	power_pole_selection_manager.setup_map(_ui)
	
	transport_bucket.global_position = initial_power_connector.global_position

func _on_placed() -> void:
	power_pole_selection_manager.show_power_pole_selection_map()

func _on_power_pole_selection_manager_power_connector_selected(power_connector: PowerConnector):
	_ui.close()
	

func _on_transport_bucket_interacted_with():
	show_ui.call(_ui)
	transport_bucket.stop()

func _on_ui_closed() -> void:
	transport_bucket.start()
	hide_ui.call(false)
