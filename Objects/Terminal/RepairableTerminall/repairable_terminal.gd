class_name RepairableTerminal
extends Terminal

@export var steel_cost: int = 5
@export var repaired_terminal_texture: Texture

@onready var inventory_requirement_interaction_area: InventoryRequirementInteractionArea = $InventoryRequirementInteractionArea
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	inventory_requirement_interaction_area.inventory_requirement.steel_cost = steel_cost

func repair() -> void:
	inventory_requirement_interaction_area.queue_free()
	sprite.texture = repaired_terminal_texture
	interaction_area.disabled = false

func _on_inventory_requirement_interaction_area_requirements_met(interactor):
	repair()
