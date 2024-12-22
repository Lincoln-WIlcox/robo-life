extends Node2D

func _physics_process(_delta):
	look_at(MouseArea.global_position)
