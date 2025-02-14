class_name DamagedUnitsDamagedShipPart
extends DamagedShipPart

@export var damaged_units: Array[DamagedUnit]
@export var map_texture: MapTexture

func _ready() -> void:
	map_texture.get_position = func() -> Vector2: return global_position
	EventBus.emit_map_entity_added(map_texture)
	for damaged_unit: DamagedUnit in damaged_units:
		track_damaged_unit(damaged_unit)

func track_damaged_unit(damaged_unit: DamagedUnit) -> void:
	damaged_unit.repaired.connect(_on_damaged_unit_repaired)

func reveal_damaged_units() -> void:
	for damaged_unit: DamagedUnit in damaged_units:
		damaged_unit.reveal_on_map()

func _on_damaged_unit_repaired() -> void:
	for damaged_unit: DamagedUnit in damaged_units:
		if not damaged_unit.get_repaired():
			return
	repair()

func repair() -> void:
	super()
	map_texture.display_texture = repaired_texture

func _on_player_detector_area_entered(area: Area2D):
	if area is PlayerArea:
		reveal_damaged_units()
