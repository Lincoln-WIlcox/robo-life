extends Node

@export var initial_tracked_damaged_ship_parts: Array[DamagedShipPart]

var _tracked_damaged_ship_parts: Array[DamagedShipPart]

signal all_damaged_ship_parts_repaired

func _ready() -> void:
	for damaged_ship_part: DamagedShipPart in initial_tracked_damaged_ship_parts:
		track_damaged_ship_part(damaged_ship_part)

func track_damaged_ship_part(damaged_ship_part: DamagedShipPart) -> void:
	damaged_ship_part.repaired.connect(_on_damaged_ship_part_repaired)
	_tracked_damaged_ship_parts.append(damaged_ship_part)

func _on_damaged_ship_part_repaired() -> void:
	for damaged_ship_part: DamagedShipPart in _tracked_damaged_ship_parts:
		if not damaged_ship_part.get_repaired():
			return
	all_damaged_ship_parts_repaired.emit()
