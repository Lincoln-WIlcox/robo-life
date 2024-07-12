class_name MousePickupArea
extends Area2D

@export var progress_bar: ProgressBar
@export var delete_node: Node
@export var item: ItemData
@export var time := .25

@onready var text_spawner: FloatAwayTextSpawner = $FloatAwayTextSpawner
@onready var timer = $Timer

signal picked_up(item: ItemData)

func _ready():
	timer.wait_time = time
	progress_bar.hide()
	progress_bar.min_value = 0
	progress_bar.max_value = timer.wait_time

func start_picking_up():
	timer.start()
	progress_bar.show()

func cancel_pickup():
	timer.stop()
	progress_bar.hide()

func _process(delta):
	progress_bar.value = timer.time_left

func _input(event):
	if event.is_action_released("pickup"):
		cancel_pickup()

func pickup():
	delete_node.queue_free()
	picked_up.emit(item)

func pickup_out_of_range():
	text_spawner.spawn_text()

func _on_timer_timeout():
	pickup()
