extends Node

@export var mouse_detect_area: MouseDetectArea
@export var delete_node: Node

func _input(event):
	if event.is_action_pressed("pickup") and mouse_detect_area.mouse_over:
		delete_node.queue_free()
