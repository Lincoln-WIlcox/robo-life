extends Node2D

@onready var item_pickup_position = $CharacterBody2D/ItemPickupPosition
@onready var interaction_area = $CharacterBody2D/InventoryRequirementInteractionArea
@onready var power_consumer: PowerConsumer = $CharacterBody2D/PowerConsumer
@onready var not_drilling: State = $StateMachine/NotDrilling
@onready var drilling: State = $StateMachine/Drilling
@onready var gravity_walk_over_pickup_spawner = $CharacterBody2D/GravityWalkOverPickupSpawner

@export var item_pickup_packed_scene: PackedScene
@export var node_to_put_item_pickup_in: Node
@export var drill: ItemData
@export var steel_amount := 20
@export var progress_bar: ProgressBar

signal item_spent(item_pickup: ItemPickup)

var _drill_on_mine := false

func _ready():
	not_drilling.is_drill_on_mine = func(): return _drill_on_mine
	drilling.is_drill_on_mine = func(): return _drill_on_mine
	gravity_walk_over_pickup_spawner.node_to_spawn_pickup_in = node_to_put_item_pickup_in
	drilling.steel_remaining = steel_amount
	progress_bar.max_value = steel_amount
	progress_bar.value = 0

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	_create_item_pickup()
	interaction_area.disable()
	_drill_on_mine = true

func _create_item_pickup() -> void:
	var item_pickup: ItemPickup = item_pickup_packed_scene.instantiate()
	item_pickup.item = drill
	node_to_put_item_pickup_in.add_child(item_pickup)
	item_pickup.global_position = item_pickup_position.global_position
	item_pickup.collected.connect(_on_item_pickup_picked_up)

func _on_item_pickup_picked_up(_item, _collector):
	interaction_area.enabled()
	_drill_on_mine = false
