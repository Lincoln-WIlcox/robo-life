class_name TransportBucketPlaceable
extends Placeable

@onready var power_connector_detection_area: Area2D = $PowerConnectorDetectionArea

@export var transport_bucket_power_pole_selection_manager_packed_scene: PackedScene
@export var environment_query_system: EnvironmentQuerySystem
@export var node_to_put_transport_buckets_in: Node

var show_ui: Callable
var hide_ui: Callable

var _nearby_power_connector: PowerConnector:
	set(new_value):
		_nearby_power_connector = new_value
		if new_value == null:
			placement_valid = false
		else:
			placement_valid = true

func _ready():
	super()
	_update_nearby_power_connector()

func _on_placed() -> void:
	var transport_bucket: TransportBucketPowerPoleSelectionManager = transport_bucket_power_pole_selection_manager_packed_scene.instantiate()
	node_to_put_transport_buckets_in.add_child(transport_bucket)
	transport_bucket.initial_power_connector = _nearby_power_connector
	transport_bucket.show_ui = show_ui
	transport_bucket.hide_ui = hide_ui
	transport_bucket.environment_query_system = environment_query_system
	transport_bucket.setup()
	queue_free()

func _on_power_connector_detection_area_area_entered(area: Area2D):
	_compare_and_update_nearby_power_connector(area)

func _on_power_connector_detection_area_area_exited(area: Area2D):
	if area == _nearby_power_connector:
		_update_nearby_power_connector()

func _update_nearby_power_connector() -> void:
	_nearby_power_connector = null
	for overlapping_area: Area2D in power_connector_detection_area.get_overlapping_areas():
		_compare_and_update_nearby_power_connector(overlapping_area)

func _compare_and_update_nearby_power_connector(new_area: Area2D) -> void:
	var new_distance := new_area.global_position.distance_to(global_position)
	var current_distance :=  _nearby_power_connector.global_position.distance_to(global_position) if _nearby_power_connector else 0.0
	if new_area is PowerConnector and (_nearby_power_connector == null or new_distance < current_distance):
		_nearby_power_connector = new_area
