extends Area2D

@export var delete_node: Node
@export var item: ItemData

func on_selected():
	pass

func on_pickup():
	delete_node.queue_free()
