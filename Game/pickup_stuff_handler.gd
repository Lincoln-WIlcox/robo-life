class_name PickupStuffHandler
extends Node

var inventory: Inventory

func update():
	var pickup_areas: Array[Area2D] = MouseArea.get_overlapping_areas().filter(func(a: Area2D): return a is MousePickupArea)
	
	if Input.is_action_just_pressed("pickup") and pickup_areas.size() > 0:
		var item: ItemData = pickup_areas[0].start_picking_up()
		if not pickup_areas[0].picked_up.is_connected(_on_pickup_picked_up):
			pickup_areas[0].picked_up.connect(_on_pickup_picked_up)

func _on_pickup_picked_up(item: ItemData):
	inventory.add_item(item)