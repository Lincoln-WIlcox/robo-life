class_name SelectablePowerPoleMapEntity
extends MapScene

signal selected

func setup_scene() -> void:
	super()
	assert(instance is SelectablePowerPole, "SelectablePowerPoleMapEntity given invalid packed scene")

func emit_selected() -> void:
	selected.emit()
