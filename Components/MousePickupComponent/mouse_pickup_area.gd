class_name MousePickupArea
extends Area2D

@export var progress_bar: ProgressBar
@export var delete_node: Node
@export var inventory_addition: InventoryAddition
@export var time := .25
@export var pickup_priority: int = 0

@onready var out_of_range_text_spawner: FloatAwayTextSpawner = $OutOfRangeTextSpawner
@onready var no_inventory_space_text_spawner: FloatAwayTextSpawner = $NoInventorySpaceTextSpawner
@onready var timer = $Timer

signal picked_up(inventory_addition: InventoryAddition)
signal pickup_timer_ended

func _ready():
	timer.wait_time = time
	progress_bar.hide()
	progress_bar.min_value = 0
	progress_bar.max_value = timer.wait_time

func start_picking_up() -> void:
	timer.start()
	progress_bar.show()

func cancel_pickup() -> void:
	timer.stop()
	progress_bar.hide()

func _process(_delta):
	progress_bar.value = timer.time_left

func _input(event):
	if event.is_action_released("pickup"):
		cancel_pickup()

func on_pickup() -> void:
	delete_node.queue_free()
	picked_up.emit(inventory_addition)

func pickup_out_of_range() -> void:
	out_of_range_text_spawner.spawn_text()

func no_space() -> void:
	no_inventory_space_text_spawner.spawn_text()

func _on_timer_timeout():
	pickup_timer_ended.emit()
