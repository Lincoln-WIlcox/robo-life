class_name PoweredDoor
extends Node2D

const INTERACTION_FAIL_TEXT = "Requires 1 Battery"

@onready var interaction_area: InventoryRequirementInteractionArea = $InventoryRequirementInteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var float_away_text_spawner: FloatAwayTextSpawner = $FloatAwayTextSpawner

@export var float_away_text_packed_scene: PackedScene

signal door_opened

var batteries := Callable(func(): return 0)

func _on_inventory_requirement_interaction_area_requirements_met(interactor):
	animation_player.play("SlideDoorUp")
	door_opened.emit()
	interaction_area.queue_free()

func _on_inventory_requirement_interaction_area_insufficient_requirements(interactor):
	float_away_text_spawner.spawn_text()
