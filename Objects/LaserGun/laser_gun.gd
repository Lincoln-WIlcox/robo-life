class_name LaserGun
extends Node2D

@onready var _laser = $Laser

@export var firing = true:
	set = _update_firing

func _ready():
	if firing == false:
		_stop_firing_laser()

func _update_firing(new_value):
	if firing and not new_value:
		_stop_firing_laser()
	elif not firing and new_value:
		_start_firing_laser()
	firing = new_value

func _stop_firing_laser():
	remove_child(_laser)

func _start_firing_laser():
	add_child(_laser)
	move_child(_laser, 0)
