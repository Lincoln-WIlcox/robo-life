@tool
class_name RockBarrier
extends Node2D

@export var node_to_put_item_pickup_in: Node
@export var item_pickup_packed_scene: PackedScene
@export var flip_sprite := false:
	set(new_value):
		flip_sprite = new_value
		
		if is_inside_tree():
			_handle_sprite_direction()
@export var drill_time := 3
@export var drill_item: ItemData
@export var day_night_cycle: DayNightCycle
@export var environment_query_system: EnvironmentQuerySystem
@export var transport_bucket_destination_queryable: TransportBucketDestinationSelectionQueryableEntity
@export var transport_bucket_destination_texture: Texture

@onready var sprite = $Sprite2D
@onready var drill_pickup_position_left = $DrillPickupPositionLeft
@onready var drill_pickup_position_right = $DrillPickupPositionRight
@onready var time_task_handler = $TimeTaskHandler
@onready var static_body = $StaticBody2D
@onready var float_away_text_spawner: FloatAwayTextSpawner = $FloatAwayTextSpawner
@onready var power_consumer := $PowerConsumer
@onready var place_item_interactable: PlaceItemInteractable = $PlaceItemInteractable

func _ready():
	transport_bucket_destination_queryable.power_connector = power_consumer
	transport_bucket_destination_queryable.connect_source(self)
	transport_bucket_destination_queryable.map_entity_setup.connect(_on_transport_bucket_destination_map_entity_setup)
	
	environment_query_system.add_entity_queryable(transport_bucket_destination_queryable)
	
	_handle_sprite_direction()
	time_task_handler.task_time = drill_time
	time_task_handler.day_night_cycle = day_night_cycle

func _on_transport_bucket_destination_map_entity_setup(map_entity: SelectableMapEntity) -> void:
	map_entity.instance.position = global_position
	map_entity.instance.use_texture(transport_bucket_destination_texture)

func _handle_sprite_direction() -> void:
	sprite.flip_v = flip_sprite
	place_item_interactable.node_to_put_item_pickup_in = node_to_put_item_pickup_in

func _on_time_task_handler_task_completed():
	queue_free()

func _make_progress() -> void:
	time_task_handler.make_progress()

func _pause_progress() -> void:
	time_task_handler.pause_progress()

func _on_power_consumer_power_requirement_met():
	if place_item_interactable.is_item_placed():
		_make_progress()

func _on_power_consumer_power_requirement_lost():
	_pause_progress()

func _on_place_item_interactable_item_placed(item_pickup: ItemPickup):
	power_consumer.active = true
	item_pickup.global_position = drill_pickup_position_left.global_position if flip_sprite else drill_pickup_position_right.global_position
	if power_consumer.enough_power_supplied:
		_make_progress()

func _on_place_item_interactable_item_picked_up():
	power_consumer.active = false
	_pause_progress()

func _on_place_item_interactable_insufficient_requirements():
	float_away_text_spawner.spawn_text()
