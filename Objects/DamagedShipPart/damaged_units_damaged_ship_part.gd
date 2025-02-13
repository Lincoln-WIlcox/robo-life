class_name DamagedUnitsDamagedShipPart
extends DamagedShipPart

@export var damaged_units: Array[DamagedUnit]

func _ready() -> void:
	for damaged_unit: DamagedUnit in damaged_units:
		track_damaged_unit(damaged_unit)

func track_damaged_unit(damaged_unit: DamagedUnit) -> void:
	damaged_unit.repaired.connect(_on_damaged_unit_repaired)

func _on_damaged_unit_repaired() -> void:
	for damaged_unit: DamagedUnit in damaged_units:
		if not damaged_unit.get_repaired():
			return
	repair()
