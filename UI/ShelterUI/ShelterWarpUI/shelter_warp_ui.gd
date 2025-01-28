class_name ShelterWarpUI 
extends Control

@onready var warp_button := $MapButtonsVbox/ButtonsContainer/ButtonsHbox/WarpButton
@onready var map_display: EntitySelectionMapDisplay = $MapButtonsVbox/ShelterSelectionMap

var _selected_shelter: SelectableMapEntity

signal shelter_selected(selected_shelter: SelectableMapEntity)
signal cancelled

func reset_selected_shelter() -> void:
	_selected_shelter = null
	warp_button.disabled = true
	map_display.reset_selected_entity()

func _on_warp_button_pressed():
	pass # Replace with function body.

func _on_return_button_pressed():
	cancelled.emit()
