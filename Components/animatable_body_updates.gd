extends AnimatableBody2D

@onready var starting_pos: = position
func _physics_process(_delta: float) -> void:
	position = starting_pos
