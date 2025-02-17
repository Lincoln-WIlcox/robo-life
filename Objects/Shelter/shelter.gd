class_name Shelter extends Node2D

@export var map_scene: MapScene
@export var selectable_map_entity: SelectableMapEntity
@export var shelter_selection_texture: Texture
@export var environment_query_system: EnvironmentQuerySystem
@export var transport_bucket_destination: TransportBucketDestinationSelectionQueryableEntity

@onready var power_connector: PowerConnector = $PowerConnector

signal transport_bucket_arrived(transport_bucket: TransportBucket)

func _ready():
	EventBus.emit_map_entity_added(map_scene)
	map_scene.scene_setup.connect(_set_map_entity_position)
	
	transport_bucket_destination.power_connector = power_connector
	transport_bucket_destination.connect_source(self)
	transport_bucket_destination.map_entity_setup.connect(_on_transport_bucket_destination_map_entity_scene_setup)
	
	if environment_query_system:
		environment_query_system.add_entity_queryable(transport_bucket_destination)

func make_selectable_map_entity() -> SelectableMapEntity:
	var new_selectable_map_entity: SelectableMapEntity = selectable_map_entity.duplicate()
	new_selectable_map_entity.source_node = self
	new_selectable_map_entity.scene_setup.connect(_on_shelter_selectable_map_entity_scene_setup.bind(new_selectable_map_entity))
	return new_selectable_map_entity

func _on_transport_bucket_destination_map_entity_scene_setup(map_entity: SelectableMapEntity) -> void:
	map_entity.instance.position = global_position
	map_entity.instance.use_texture(shelter_selection_texture)

func _set_map_entity_position() -> void:
	map_scene.instance.position = global_position

func _on_shelter_selectable_map_entity_scene_setup(map_entity: SelectableMapEntity) -> void:
	map_entity.instance.position = global_position
	map_entity.instance.use_texture(shelter_selection_texture)

func _on_power_connector_transport_bucket_arrived(transport_bucket: TransportBucket):
	transport_bucket_arrived.emit(transport_bucket)
