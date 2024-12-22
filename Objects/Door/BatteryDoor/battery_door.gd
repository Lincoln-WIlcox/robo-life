class_name PoweredDoor
extends Door

const INTERACTION_FAIL_TEXT = "Requires 1 Battery"

@onready var float_away_text_spawner: FloatAwayTextSpawner = $FloatAwayTextSpawner
@onready var interaction_area: InventoryRequirementInteractionArea = $InventoryRequirementInteractionArea

signal door_opened

func _on_inventory_requirement_interaction_area_insufficient_requirements(_interactor):
	float_away_text_spawner.spawn_text()

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	open()
	door_opened.emit()
	interaction_area.queue_free()
