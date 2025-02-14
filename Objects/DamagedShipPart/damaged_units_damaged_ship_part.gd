class_name DamagedUnitsDamagedShipPart
extends DamagedShipPart

@export var damaged_units: Array[DamagedUnit]

var _revealed_damaged_units: bool = false

func _ready() -> void:
	super()
	for damaged_unit: DamagedUnit in damaged_units:
		track_damaged_unit(damaged_unit)

func track_damaged_unit(damaged_unit: DamagedUnit) -> void:
	damaged_unit.repaired.connect(_on_damaged_unit_repaired)

func reveal_damaged_units() -> void:
	for damaged_unit: DamagedUnit in damaged_units:
		damaged_unit.reveal_on_map()
	_revealed_damaged_units = true

func _on_damaged_unit_repaired() -> void:
	for damaged_unit: DamagedUnit in damaged_units:
		if not damaged_unit.get_repaired():
			return
	repair()

func _on_player_detector_area_entered(area: Area2D):
	if area is PlayerArea and not _revealed_damaged_units:
		reveal_damaged_units()
