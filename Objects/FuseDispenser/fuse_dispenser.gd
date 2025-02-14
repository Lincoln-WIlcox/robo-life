class_name FuseDispenser
extends Node2D

@export var day_night_cycle: DayNightCycle
@export var node_to_put_fuse_pickup_in: Node
@export var fuse_item: ItemData

@onready var inventory_requirement_interaction_area: InventoryRequirementInteractionArea = $InventoryRequirementInteractionArea
@onready var time_task_handler: TimeTaskHandler = $TimeTaskHandler
@onready var item_spawner: ItemSpawner = $ItemSpawner

var _crafting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	time_task_handler.day_night_cycle = day_night_cycle
	item_spawner.node_to_put_drops_in = node_to_put_fuse_pickup_in

func _on_inventory_requirement_interaction_area_requirements_met(interactor):
	inventory_requirement_interaction_area.disable()
	time_task_handler.make_progress()
	_crafting = true

func _on_time_task_handler_task_completed():
	item_spawner.drop_item(fuse_item)
	
	inventory_requirement_interaction_area.enable()
	time_task_handler.pause_progress()
	time_task_handler.reset_progress()
	_crafting = false
