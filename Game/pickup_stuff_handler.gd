class_name PickupStuffHandler
extends Node

var inventory: Inventory
var mouse_detect_area: MouseDetectArea
var pickup: Callable

func update():
	var pickup_areas: Array[Area2D] = MouseArea.get_overlapping_areas().filter(func(a: Area2D): return a is MousePickupArea)
	
	if pickup.call() and pickup_areas.size() > 0:
		if mouse_detect_area.mouse_over:
			#var item: ItemData = pickup_areas[0].start_picking_up()
			pickup_areas[0].start_picking_up()
			if not pickup_areas[0].picked_up.is_connected(_on_pickup_picked_up):
				pickup_areas[0].picked_up.connect(_on_pickup_picked_up)
		else:
			pickup_areas[0].pickup_out_of_range()

func _on_pickup_picked_up(item: ItemData):
	inventory.add_item(item)
