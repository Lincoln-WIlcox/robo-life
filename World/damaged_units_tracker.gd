extends Node

@export var initial_tracked_damaged_units: Array[DamagedUnit]

var _tracked_damaged_units: Array[DamagedUnit]

signal all_damaged_units_repaired

func _ready() -> void:
	for damaged_unit: DamagedUnit in initial_tracked_damaged_units:
		track_damaged_unit(damaged_unit)

func track_damaged_unit(damaged_unit: DamagedUnit) -> void:
	damaged_unit.repaired.connect(_on_damaged_unit_repaired)
	_tracked_damaged_units.append(damaged_unit)

func _on_damaged_unit_repaired() -> void:
	for damaged_unit: DamagedUnit in _tracked_damaged_units:
		if not damaged_unit.get_repaired():
			return
	all_damaged_units_repaired.emit()
