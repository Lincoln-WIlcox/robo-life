class_name TransportBucket
extends Node2D

##contains an inventory and moves along a given path.

@onready var mouse_pickup_area: MousePickupArea = $Path2D/PathFollow2D/MousePickupArea
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D

@export var initial_inventory: Inventory
@export var transport_bucket_item: ItemData
@export var speed: float = 1
@export var item_grid_size := Vector2i(2,2)

var _inventory: Inventory = Inventory.new()
var _path: Path2D
var _moving := true
var _being_picked_up := false

signal interacted_with

func _ready():
	if initial_inventory:
		_inventory = initial_inventory
	
	if not _inventory.item_grid:
		var item_grid: ItemGrid = ItemGrid.new()
		item_grid.size = item_grid_size
		_inventory.item_grid = item_grid
	
	update_inventory_addition()
	_inventory.changed.connect(update_inventory_addition)

func update_inventory_addition() -> void:
	var inventory_addition: InventoryAddition = InventoryAddition.new()
	if _inventory:
		inventory_addition = _inventory.to_inventory_addition()
	inventory_addition.add_item(transport_bucket_item)
	mouse_pickup_area.inventory_addition = inventory_addition

func start() -> void:
	_moving = true

func stop() -> void:
	_moving = false

func get_inventory() -> Inventory:
	return _inventory

func _physics_process(delta: float):
	if _can_move() and path_follow.progress_ratio < 1:
		var move_per_time := Utils.float_per_frame_to_float_per_time(speed, delta)
		path_follow.progress += move_per_time

func _can_move() -> bool:
	return _moving and not _being_picked_up

func _on_mouse_pickup_area_started_picking_up():
	_being_picked_up = true

func _on_mouse_pickup_area_cancelled_picking_up():
	_being_picked_up = false

func _on_mouse_interaction_area_interacted_with():
	interacted_with.emit()
