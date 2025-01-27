class_name SelectableMapEntity
extends MapScene

signal selected

func setup_scene() -> void:
	super()
	assert(instance is SelectableMapScene, "SelectableMapEntity given invalid packed scene")

func emit_selected() -> void:
	selected.emit()
