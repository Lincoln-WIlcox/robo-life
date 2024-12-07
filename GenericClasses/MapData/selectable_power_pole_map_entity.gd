class_name SelectablePowerPoleMapEntity
extends MapScene

func setup_scene() -> void:
	super()
	assert(instance is SelectablePowerPole, "SelectablePowerPoleMapEntity given invalid packed scene")
