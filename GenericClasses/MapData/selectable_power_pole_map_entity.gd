class_name SelectablePowerPoleMapEntity
extends MapScene

@export var initial_position: Vector2

func setup_scene() -> void:
	super()
	assert(instance is SelectablePowerPole, "SelectablePowerPoleMapEntity given invalid packed scene")
	instance.position = initial_position
