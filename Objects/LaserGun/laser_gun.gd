class_name LaserGun
extends Node2D

@onready var _laser := $Laser

@export var firing = true:
	set = _update_firing
@export var heat_amount := 1:
	set(new_value):
		if is_node_ready():
			_laser.heat_amount = new_value
		heat_amount = new_value

func _ready():
	if firing == false:
		_stop_firing_laser()
	_laser.heat_amount = heat_amount

func _update_firing(new_value):
	if not is_node_ready():
		await ready
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
