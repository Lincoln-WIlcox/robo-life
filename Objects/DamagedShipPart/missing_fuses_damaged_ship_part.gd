class_name MissingFusesDamagedShipPart
extends DamagedShipPart

@export var fuse_num: int = 6
@export var fuse_item: ItemData

@onready var inventory_requirement_interaction_area = $InventoryRequirementInteractionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	for i: int in range(fuse_num):
		inventory_requirement_interaction_area.inventory_requirement.costs_items.append(fuse_item)

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	repair()

func repair() -> void:
	super()
	inventory_requirement_interaction_area.queue_free()
