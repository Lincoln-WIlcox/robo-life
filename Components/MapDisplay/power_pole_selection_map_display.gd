class_name PowerPoleSelectionMapDisplay
extends MapDisplay

var _selected_power_pole: SelectablePowerPole

signal power_pole_selected(selectable_power_pole_map_entity: SelectablePowerPoleMapEntity)

func _display_map_entity(map_entity: MapEntity) -> void:
	if map_entity is SelectablePowerPoleMapEntity:
		var selectable_power_pole: SelectablePowerPole = _display_map_scene(map_entity)
		selectable_power_pole.pressed.connect(_on_selectable_power_pole_pressed.bind(selectable_power_pole, map_entity))
		return
	super(map_entity)

func _on_selectable_power_pole_pressed(selectable_power_pole: SelectablePowerPole, map_entity: SelectablePowerPoleMapEntity) -> void:
	_update_selected_power_pole(selectable_power_pole)
	power_pole_selected.emit(map_entity)

func _update_selected_power_pole(new_selectable_power_pole: SelectablePowerPole) -> void:
	if _selected_power_pole:
		_selected_power_pole.deselect()
	_selected_power_pole = new_selectable_power_pole
	_selected_power_pole.select()

func reset_selected_power_pole() -> void:
	if _selected_power_pole:
		_selected_power_pole.deselect()
	_selected_power_pole = null
