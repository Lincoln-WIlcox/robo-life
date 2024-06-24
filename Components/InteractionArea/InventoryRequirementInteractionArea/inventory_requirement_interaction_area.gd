@tool
class_name InventoryRequirementInteractionArea
extends InteractionArea

@export var inventory_requirement: InventoryRequirement

signal requirements_met(interactor: Object)
signal insufficient_requirements(interactor: Object)

func meet_requirements(interactor: Object) -> void:
	requirements_met.emit(interactor)

func fail_requirements(interactor: Object) -> void:
	insufficient_requirements.emit(interactor)
