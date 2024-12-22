@tool
class_name RockBarrier
extends Node2D

@onready var sprite = $Sprite2D
@onready var drill_pickup_position_left = $DrillPickupPositionLeft
@onready var drill_pickup_position_right = $DrillPickupPositionRight
@onready var interaction_area = $InventoryRequirementInteractionArea
@onready var time_task_handler = $TimeTaskHandler
@onready var static_body = $StaticBody2D
@onready var inventory_requirement_interaction_area: InventoryRequirementInteractionArea = $InventoryRequirementInteractionArea
@onready var float_away_text_spawner: FloatAwayTextSpawner = $FloatAwayTextSpawner

@export var item_pickup_packed_scene: PackedScene
@export var flip_sprite := false:
	set(new_value):
		flip_sprite = new_value
		
		if is_inside_tree():
			_handle_sprite_direction()
@export var drill_time := 3
@export var drill_item: ItemData
@export var day_night_cycle: DayNightCycle

signal item_spent(item_pickup: ItemPickup)

func _ready():
	time_task_handler.task_time = drill_time
	time_task_handler.day_night_cycle = day_night_cycle
	inventory_requirement_interaction_area.insufficient_requirements.connect(func(_interactor): float_away_text_spawner.spawn_text())

func _handle_sprite_direction() -> void:
	sprite.flip_v = flip_sprite

func _on_time_task_handler_task_completed():
	queue_free()

func _create_item_pickup():
	var item_pickup: ItemPickup = item_pickup_packed_scene.instantiate()
	item_pickup.item = drill_item
	item_pickup.collected.connect(_on_item_pickup_collected)
	if !flip_sprite:
		item_pickup.global_position = drill_pickup_position_right.global_position
	else:
		item_pickup.global_position = drill_pickup_position_left.global_position
	item_spent.emit(item_pickup)

func _on_item_pickup_collected(_item, _collector):
	interaction_area.disabled = false
	time_task_handler.pause_progress()

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	interaction_area.disabled = true
	_create_item_pickup()
	time_task_handler.make_progress()
