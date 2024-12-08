class_name PickupStuffHandler
extends Node

var inventory: Inventory
var mouse_detect_area: MouseDetectArea
var pickup: Callable

var just_started_picking_up := false

func update():
	just_started_picking_up = false
	var pickup_areas: Array[Area2D] = MouseArea.get_overlapping_areas().filter(func(a: Area2D): return a is MousePickupArea)
	
	if pickup.call() and pickup_areas.size() > 0:
		just_started_picking_up = true
		var pickup_area: MousePickupArea = pickup_areas[0]
		
		if not inventory.can_add_addition(pickup_area.inventory_addition):
			pickup_area.no_space()
		else:
			if mouse_detect_area.mouse_over:
				#var item: ItemData = pickup_area.start_picking_up()
				pickup_area.start_picking_up()
				if not pickup_area.pickup_timer_ended.is_connected(_on_pickup_timer_ended.bind(pickup_area)):
					pickup_area.pickup_timer_ended.connect(_on_pickup_timer_ended.bind(pickup_area))
			else:
				pickup_area.pickup_out_of_range()

func _on_pickup_timer_ended(pickup_area: MousePickupArea):
	if inventory.can_add_addition(pickup_area.inventory_addition):
		inventory.add_addition(pickup_area.inventory_addition)
		pickup_area.on_pickup()
	else:
		pickup_area.no_space()
