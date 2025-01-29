class_name ShelterWarpUI 
extends Control

@onready var warp_button := $MapButtonsVbox/ButtonsContainer/ButtonsHbox/WarpButton
@onready var map_display: EntitySelectionMapDisplay = $MapButtonsVbox/ShelterSelectionMap

var _selected_shelter_map_entity: SelectableMapEntity

signal cancelled

func reset_selected_shelter() -> void:
	_selected_shelter_map_entity = null
	warp_button.disabled = true
	map_display.reset_selected_entity()

func display_map_data(map_data: MapData) -> void:
	if !is_node_ready():
		await ready
	map_display.display_map_data(map_data)

func _on_warp_button_pressed():
	_selected_shelter_map_entity.emit_selected()

func _on_return_button_pressed():
	cancelled.emit()

func _on_shelter_selection_map_entity_selected(selectable_map_entity: SelectableMapEntity) -> void:
	_selected_shelter_map_entity = selectable_map_entity
	warp_button.disabled = selectable_map_entity == null
