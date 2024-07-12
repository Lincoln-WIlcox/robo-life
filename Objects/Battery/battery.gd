extends Node2D

func _on_walk_over_item_pickup_area_collected():
	queue_free()
