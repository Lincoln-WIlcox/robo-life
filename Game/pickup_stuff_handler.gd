class_name PickupStuffHandler
extends Node

var inventory: Inventory

func update():
	var pickup_areas: Array[Area2D] = MouseArea.get_overlapping_areas().filter(func(a: Area2D): return a is MousePickupArea)
	
	if Input.is_action_just_pressed("pickup") and pickup_areas.size() > 0:
		var item: ItemData = pickup_areas[0].pickup()
		inventory.add_item(item)
