class_name MissingFusesDamagedShipPart
extends DamagedShipPart

const LABEL_STRING = "%s/%s" 

@export var fuses_required: int = 6
@export var fuse_item: ItemData
@export var environment_query_system: EnvironmentQuerySystem
@export var transport_bucket_destination_queryable: TransportBucketDestinationSelectionQueryableEntity
@export var transport_bucket_destination_texture: Texture

var fuses_given: int = 0

@onready var inventory_requirement_interaction_area = $InventoryRequirementInteractionArea
@onready var label = $Label
@onready var power_connector = $PowerConnector

func _ready():
	transport_bucket_destination_queryable.connect_source(self)
	transport_bucket_destination_queryable.power_connector = power_connector
	transport_bucket_destination_queryable.map_entity_setup.connect(_on_transport_bucket_destination_setup)
	
	environment_query_system.add_entity_queryable(transport_bucket_destination_queryable)
	
	_update_label()

func repair() -> void:
	super()
	inventory_requirement_interaction_area.queue_free()

func add_fuse() -> void:
	fuses_given += 1
	_update_label()

func _on_transport_bucket_destination_setup(map_entity: SelectableMapEntity) -> void:
	map_entity.instance.position = global_position
	map_entity.instance.use_texture(transport_bucket_destination_texture)
	
	var use_texture = repaired_texture if _is_repaired else transport_bucket_destination_texture
	map_entity.instance.use_texture(use_texture)
	
	repaired.connect(func() -> void: if map_entity: map_entity.instance.use_texture(repaired_texture))

func _update_label() -> void:
	label.text = LABEL_STRING % [fuses_given, fuses_required]

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	add_fuse()
	if fuses_given >= fuses_required:
		repair()
