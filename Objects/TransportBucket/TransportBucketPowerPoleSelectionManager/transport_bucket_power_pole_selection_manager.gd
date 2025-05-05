class_name TransportBucketPowerPoleSelectionManager
extends Node

@onready var transport_bucket: TransportBucket = $TransportBucket
@onready var power_pole_selection_manager: Node = $PowerPoleSelectionManager
@onready var path_handler = $PathHandler

@export var environment_query_system: EnvironmentQuerySystem
@export var initial_power_connector: PowerConnector
@export var transport_bucket_ui_packed_scene: PackedScene

var show_ui: Callable
var hide_ui: Callable
var get_revealed_sectors: Callable

var _ui: TransportBucketUI

func setup() -> void:
	var player_queryables: Array[PlayerQueryable]
	var player_queryables_assigner: Array = environment_query_system.get_queryables_by_class(PlayerQueryable)
	player_queryables.assign(player_queryables_assigner)
	
	_ui = transport_bucket_ui_packed_scene.instantiate()
	#this should change later; the transport bucket will need to get an inventory from whatever interacted with it.
	_ui.player_inventory = player_queryables[0].player_inventory
	_ui.transport_bucket_inventory = transport_bucket.get_inventory()
	_ui.closed.connect(_on_ui_closed)
	
	power_pole_selection_manager.initial_power_connector = initial_power_connector
	power_pole_selection_manager.environment_query_system = environment_query_system
	power_pole_selection_manager.get_revealed_sectors = get_revealed_sectors
	power_pole_selection_manager.setup_map(_ui)
	
	transport_bucket.set_path_follow_position(initial_power_connector.global_position)

func _on_placed() -> void:
	power_pole_selection_manager.show_power_pole_selection_map()

func _on_power_pole_selection_manager_power_connector_selected(power_connector: PowerConnector):
	_ui.close()
	if path_handler.path_is_made():
		path_handler.reroute_to(power_connector)
	else:
		path_handler.make_new_path(initial_power_connector, power_connector)

func _on_transport_bucket_interacted_with():
	show_ui.call(_ui)
	transport_bucket.stop()

func _on_ui_closed() -> void:
	transport_bucket.start()
	hide_ui.call()

func _on_transport_bucket_tree_exiting():
	queue_free()

func on_sector_revealed(sector_coords: Vector2i) -> void:
	power_pole_selection_manager.reveal_sector(sector_coords)

func _on_transport_bucket_reached_end_of_path():
	path_handler.get_last_power_connector().emit_transport_bucket_arrived(transport_bucket)

func _on_transport_bucket_picked_up():
	queue_free()

func _on_transport_bucket_range_left():
	hide_ui.call()
