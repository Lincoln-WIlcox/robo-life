class_name PickupStuffHandler
extends Node

var inventory: Inventory
var cursor_detect_area: CursorDetectArea
var pickup: Callable

var just_started_picking_up := false

func update():
	just_started_picking_up = false
	var pickup_areas: Array[CursorPickupArea]
	var pickup_areas_assigner: Array[Area2D] = MouseArea.get_overlapping_areas().filter(func(a: Area2D): return a is CursorPickupArea)
	pickup_areas.assign(pickup_areas_assigner)
	
	if pickup.call() and pickup_areas.size() > 0:
		just_started_picking_up = true
		var highest_priority: int = pickup_areas.reduce(func(agg: int, area: CursorPickupArea): return max(agg, area.pickup_priority), -INF)
		var areas_with_highest_priorty = pickup_areas.filter(func(area: CursorPickupArea): return area.pickup_priority >= highest_priority)
		var pickup_area: CursorPickupArea = areas_with_highest_priorty[0]
		
		if not inventory.can_add_addition(pickup_area.inventory_addition):
			pickup_area.no_space()
		else:
			if cursor_detect_area.mouse_over:
				#var item: ItemData = pickup_area.start_picking_up()
				pickup_area.start_picking_up()
				if not pickup_area.pickup_timer_ended.is_connected(_on_pickup_timer_ended.bind(pickup_area)):
					pickup_area.pickup_timer_ended.connect(_on_pickup_timer_ended.bind(pickup_area))
			else:
				pickup_area.pickup_out_of_range()

func _on_pickup_timer_ended(pickup_area: CursorPickupArea):
	if inventory.can_add_addition(pickup_area.inventory_addition):
		inventory.add_addition(pickup_area.inventory_addition)
		pickup_area.on_pickup()
	else:
		pickup_area.no_space()
