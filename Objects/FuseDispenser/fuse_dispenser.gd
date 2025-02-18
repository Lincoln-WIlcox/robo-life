class_name FuseDispenser
extends Node2D

@export var day_night_cycle: DayNightCycle
@export var node_to_put_fuse_pickup_in: Node
@export var fuse_item: ItemData
@export var environment_query_system: EnvironmentQuerySystem
@export var transport_bucket_destination: TransportBucketDestinationSelectionQueryableEntity
@export var map_entity_texture: Texture

@onready var inventory_requirement_interaction_area: InventoryRequirementInteractionArea = $InventoryRequirementInteractionArea
@onready var time_task_handler: TimeTaskHandler = $TimeTaskHandler
@onready var item_spawner: ItemSpawner = $ItemSpawner
@onready var power_consumer: PowerConsumer = $PowerConsumer

var _crafting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	time_task_handler.day_night_cycle = day_night_cycle
	item_spawner.node_to_put_drops_in = node_to_put_fuse_pickup_in
	
	transport_bucket_destination.power_connector = power_consumer
	transport_bucket_destination.connect_source(self)
	transport_bucket_destination.map_entity_setup.connect(_on_selectable_map_entity_scene_setup)
	
	if environment_query_system:
		environment_query_system.add_entity_queryable(transport_bucket_destination)

func _on_selectable_map_entity_scene_setup(map_entity: SelectableMapEntity) -> void:
	map_entity.instance.position = global_position
	map_entity.instance.use_texture(map_entity_texture)

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	inventory_requirement_interaction_area.disable()
	time_task_handler.make_progress()
	_crafting = true
	power_consumer.active = true

func _on_time_task_handler_task_completed():
	item_spawner.drop_item(fuse_item)
	
	inventory_requirement_interaction_area.enable()
	time_task_handler.pause_progress()
	time_task_handler.reset_progress()
	_crafting = false
	power_consumer.active = false

func _on_power_consumer_power_requirement_met():
	if not _crafting:
		inventory_requirement_interaction_area.enable()
	else:
		time_task_handler.make_progress()

func _on_power_consumer_power_requirement_lost():
	if not _crafting:
		inventory_requirement_interaction_area.disable()
	else:
		time_task_handler.pause_progress()
