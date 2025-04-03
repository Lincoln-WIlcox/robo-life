class_name RepairableTerminal
extends Node2D

@export var steel_cost: int
@export var trigger: Trigger
@export var one_time_activation: bool = false
@export var repaired_terminal_texture: Texture

@onready var inventory_requirement_interaction_area: InventoryRequirementInteractionArea = $InventoryRequirementInteractionArea
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	inventory_requirement_interaction_area.inventory_requirement.steel_cost = steel_cost

func repair() -> void:
	inventory_requirement_interaction_area.queue_free()
	sprite.texture = repaired_terminal_texture
	interaction_area.disabled = false

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	repair()

func _on_interaction_area_interacted_with(interactor):
	trigger.toggle()
	if one_time_activation:
		interaction_area.queue_free()
