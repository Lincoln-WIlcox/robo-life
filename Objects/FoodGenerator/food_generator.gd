class_name FoodGenerator
extends Node2D

##Accepts some steel steel and gives a random amount of food.

const MINIMUM_FOOD: int = 3
const MAXIMUM_FOOD: int = 7

@export var day_night_cycle: DayNightCycle
@export var node_to_put_food_in: Node

@onready var gravity_walk_over_pickup_spawner: GravityWalkOverPickupSpawner = $GravityWalkOverPickupSpawner
@onready var inventory_requirement_interaction_area: InventoryRequirementInteractionArea = $InventoryRequirementInteractionArea
@onready var time_task_handler: TimeTaskHandler = $TimeTaskHandler
@onready var float_away_text_spawner: FloatAwayTextSpawner = $FloatAwayTextSpawner

func _ready():
	time_task_handler.day_night_cycle = day_night_cycle
	gravity_walk_over_pickup_spawner.node_to_spawn_pickup_in = node_to_put_food_in

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	inventory_requirement_interaction_area.disabled = true
	time_task_handler.make_progress()

func _on_time_task_handler_task_completed():
	time_task_handler.reset_progress()
	inventory_requirement_interaction_area.disabled = false
	
	var new_food_amount: int = randi_range(MINIMUM_FOOD, MAXIMUM_FOOD)
	gravity_walk_over_pickup_spawner.spawn_amount = new_food_amount
	
	gravity_walk_over_pickup_spawner.spawn()

func _on_inventory_requirement_interaction_area_insufficient_requirements(_interactor):
	float_away_text_spawner.spawn_text()
