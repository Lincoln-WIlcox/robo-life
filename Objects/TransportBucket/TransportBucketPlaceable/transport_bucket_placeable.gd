class_name TransportBucketPlaceable
extends Placeable

@onready var power_connector_detection_area: Area2D = $PowerConnectorDetectionArea

@export var transport_bucket_packed_scene: PackedScene

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

func place_transport_bucket_in_node(node: Node) -> void:
	var transport_bucket: TransportBucket = transport_bucket_packed_scene.instantiate()
	node.add_child(transport_bucket)
	transport_bucket.global_position = _nearby_power_connector.global_position
	queue_free()

func _on_power_connector_detection_area_area_entered(area: Area2D):
	_compare_and_update_nearby_power_connector(area)

func _on_power_connector_detection_area_area_exited(area: Area2D):
	if area == _nearby_power_connector:
		_update_nearby_power_connector()

func _update_nearby_power_connector() -> void:
	var overlapping_areas: Array[Area2D] = power_connector_detection_area.get_overlapping_areas()
	_nearby_power_connector = null
	for overlapping_area: Area2D in power_connector_detection_area.get_overlapping_areas():
		_compare_and_update_nearby_power_connector(overlapping_area)

func _compare_and_update_nearby_power_connector(new_area: Area2D) -> void:
	var new_distance := new_area.global_position.distance_to(global_position)
	var current_distance :=  _nearby_power_connector.global_position.distance_to(global_position) if _nearby_power_connector else 0.0
	if new_area is PowerConnector and (_nearby_power_connector == null or new_distance < current_distance):
		_nearby_power_connector = new_area
