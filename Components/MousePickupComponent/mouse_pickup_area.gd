class_name MousePickupArea
extends Area2D

@export var delete_node: Node
@export var item: ItemData

func on_selected():
	pass

func pickup() -> ItemData:
	delete_node.queue_free()
	return item
