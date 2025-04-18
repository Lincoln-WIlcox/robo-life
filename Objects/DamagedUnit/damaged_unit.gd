class_name DamagedUnit
extends Node2D

@export var repaired_texture: Texture
@export var day_night_cycle: DayNightCycle
@export var node_to_put_item_pickup_in: Node
@export var map_texture: MapTexture
@export var environment_query_system: EnvironmentQuerySystem
@export var transport_bucket_destination_queryable: TransportBucketDestinationSelectionQueryableEntity
@export var transport_bucket_destination_texture: Texture

var _is_repaired: bool = false

@onready var power_consumer: PowerConsumer = $PowerConsumer
@onready var sprite: Sprite2D = $Sprite2D
@onready var time_task_handler: TimeTaskHandler = $TimeTaskHandler
@onready var place_item_interactable: PlaceItemInteractable = $PlaceItemInteractable
@onready var _unrepaired_texture: Texture = sprite.texture

signal repaired
signal unrepaired

func _ready():
	transport_bucket_destination_queryable.connect_source(self)
	transport_bucket_destination_queryable.power_connector = power_consumer
	transport_bucket_destination_queryable.map_entity_setup.connect(_on_transport_bucket_destination_map_entity_scene_setup)
	
	environment_query_system.add_entity_queryable(transport_bucket_destination_queryable)
	
	map_texture.get_position = func() -> Vector2: return global_position
	place_item_interactable.node_to_put_item_pickup_in = node_to_put_item_pickup_in
	time_task_handler.day_night_cycle = day_night_cycle

func reveal_on_map() -> void:
	EventBus.emit_map_entity_added(map_texture)

func get_repaired() -> bool:
	return _is_repaired

func repair() -> void:
	_is_repaired = true
	sprite.texture = repaired_texture
	map_texture.display_texture = repaired_texture
	repaired.emit()

func unrepair() -> void:
	_is_repaired = false
	sprite.texture = _unrepaired_texture
	map_texture.display_texture = _unrepaired_texture
	unrepaired.emit()

func _on_transport_bucket_destination_map_entity_scene_setup(map_entity: SelectableMapEntity) -> void:
	map_entity.instance.position = global_position
	
	var use_texture = repaired_texture if _is_repaired else transport_bucket_destination_texture
	map_entity.instance.use_texture(use_texture)
	
	repaired.connect(func() -> void: if map_entity: map_entity.instance.use_texture(repaired_texture))

func _on_mouse_interaction_area_interacted_with():
	repair()

func _on_place_item_interactable_item_placed(_item_pickup):
	if not time_task_handler.task_complete():
		power_consumer.active = true
		if power_consumer.enough_power_supplied:
			time_task_handler.make_progress()

func _on_place_item_interactable_item_picked_up():
	power_consumer.active = false
	time_task_handler.pause_progress()

func _on_power_consumer_power_requirement_met():
	if not time_task_handler.task_complete():
		if place_item_interactable.is_item_placed():
			time_task_handler.make_progress()

func _on_power_consumer_power_requirement_lost():
	time_task_handler.pause_progress()

func _on_time_task_handler_task_completed():
	repair()
	power_consumer.active = false
