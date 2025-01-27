class_name PowerPoleSelectionMap
extends Control

@onready var map_display: EntitySelectionMapDisplay = $ContentDivider/SelectableMapDisplay
@onready var confirm_button: Button = $ContentDivider/ConfirmMargin/ButtonsContainer/MarginContainer/ConfirmButton

var _selected_power_pole: SelectableMapEntity

signal power_pole_selected(selected_power_pole: SelectableMapEntity)
signal cancelled

func _on_confirm_button_pressed():
	_selected_power_pole.emit_selected()

func display_map_data(map_data: MapData) -> void:
	if !is_node_ready():
		await ready
	map_display.display_map_data(map_data)

func reset_selected_power_pole() -> void:
	_selected_power_pole = null
	confirm_button.disabled = true
	map_display.reset_selected_entity()

func emit_power_pole_selected(selected_power_pole: SelectableMapEntity) -> void:
	power_pole_selected.emit(selected_power_pole)

func _on_cancel_button_pressed():
	cancelled.emit()

func _on_selectable_map_display_entity_selected(selectable_power_pole_map_entity: SelectableMapEntity):
	_selected_power_pole = selectable_power_pole_map_entity
	confirm_button.disabled = not _selected_power_pole
