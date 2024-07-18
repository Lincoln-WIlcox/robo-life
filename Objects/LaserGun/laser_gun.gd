extends Node2D

@onready var _laser = $Laser

@export var firing = true:
	set = _update_firing

func _ready():
	if firing == false:
		remove_child(_laser)

func _update_firing(new_value):
	if firing and not new_value:
		remove_child(_laser)
	elif not firing and new_value:
		add_child(_laser)
		move_child(_laser, 0)
	firing = new_value
