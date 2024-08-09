class_name Target
extends Marker2D

@export var following: Node2D:
	set(new_value):
		following = new_value
		if following:
			#ensures the node this is following gets its physics processed first
			process_physics_priority = following.process_physics_priority - 1

func _physics_process(delta):
	global_position = following.global_position if following else global_position
