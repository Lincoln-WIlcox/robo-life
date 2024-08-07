extends Node2D

func _physics_process(delta):
	look_at(MouseArea.global_position)
