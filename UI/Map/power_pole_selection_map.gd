class_name PowerPoleSelectionMap
extends Control

@onready var map_display: MapDisplay = $ContentDivider/PowerPoleSelectionMapDisplay
@onready var confirm_button: Button = $ContentDivider/ConfirmMargin/ConfirmButton

var _selected_power_pole: SelectablePowerPoleMapEntity

signal power_pole_selected(selected_power_pole: SelectablePowerPoleMapEntity)

func _on_power_pole_selection_map_display_power_pole_selected(selectable_power_pole_map_entity: SelectablePowerPoleMapEntity):
	_selected_power_pole = selectable_power_pole_map_entity
	confirm_button.disabled = not _selected_power_pole

func _on_confirm_button_pressed():
	_selected_power_pole.selected.emit()

func display_map_data(map_data: MapData) -> void:
	if !is_node_ready():
		await ready
	map_display.display_map_data(map_data)

func reset_selected_power_pole() -> void:
	_selected_power_pole = null
	confirm_button.disabled = true
	map_display.reset_selected_power_pole()
