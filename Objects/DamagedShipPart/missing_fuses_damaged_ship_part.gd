class_name MissingFusesDamagedShipPart
extends DamagedShipPart

const LABEL_STRING = "%s/%s" 

@export var fuses_required: int = 6
@export var fuse_item: ItemData

var fuses_given: int = 0

@onready var inventory_requirement_interaction_area = $InventoryRequirementInteractionArea
@onready var label = $Label

func repair() -> void:
	super()
	inventory_requirement_interaction_area.queue_free()

func add_fuse() -> void:
	fuses_given += 1
	_update_label()

func _update_label() -> void:
	label.text = LABEL_STRING % [fuses_given, fuses_required]

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	add_fuse()
	if fuses_given >= fuses_required:
		repair()
