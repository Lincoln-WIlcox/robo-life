extends Control

@onready var map_display: MapDisplay = $ContentDivider/PowerPoleSelectionMapDisplay
@onready var confirm_button: Button = $ContentDivider/ConfirmMargin/ConfirmButton
@export var map_data: MapData

var _selected_power_pole: SelectablePowerPoleMapEntity

signal power_pole_selected(selected_power_pole: SelectablePowerPoleMapEntity)

func _ready():
	map_display.display_map_data(map_data)

func _on_power_pole_selection_map_display_power_pole_selected(selectable_power_pole_map_entity: SelectablePowerPoleMapEntity):
	_selected_power_pole = selectable_power_pole_map_entity
	confirm_button.disabled = not _selected_power_pole

func _on_confirm_button_pressed():
	power_pole_selected.emit(_selected_power_pole)
