class_name TransportBucket
extends Node2D

##contains an inventory and moves along a given path.

@onready var mouse_pickup_area: CursorPickupArea = $Path2D/PathFollow2D/TransportBucketContent/CursorPickupArea
@onready var mouse_interaction_area: MouseInteractionArea = $Path2D/PathFollow2D/TransportBucketContent/MouseInteractionArea
@onready var transport_bucket_content: Node2D = $Path2D/PathFollow2D/TransportBucketContent
@onready var body = $CharacterBody2D
@onready var path: Path2D = $Path2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var gravity_component: GravityComponent = $GravityComponent

@export var initial_inventory: Inventory
@export var transport_bucket_item: ItemData
@export var speed: float = 1.3

var _inventory: Inventory
var _moving := true
var _being_picked_up := false

signal interacted_with
signal disconnected_from_path

func _ready():
	_inventory = initial_inventory.duplicate()
	
	update_inventory_addition()
	_inventory.changed.connect(update_inventory_addition)

func set_path_follow_position(new_position: Vector2) -> void:
	path_follow.global_position = new_position

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

func use_curve(new_curve: Curve2D) -> void:
	path.curve = new_curve
	path_follow.progress = 0

func disconnect_from_path() -> void:
	path_follow.remove_child(transport_bucket_content)
	body.add_child(transport_bucket_content)
	body.global_position = path_follow.global_position
	gravity_component.active = true
	mouse_interaction_area.monitorable = false
	mouse_interaction_area.monitoring = false
	disconnected_from_path.emit()

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
