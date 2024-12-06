extends Control

@onready var map_display: MapDisplay = $ContentDivider/MapDisplay
@onready var confirm_button: Button = $ContentDivider/ConfirmMargin/ConfirmButton
@export var map_data: MapData

var _selected_power_pole: SelectablePowerPole

signal power_pole_selected(selectable_power_pole: SelectablePowerPole)

func _ready():
	map_display.display_map_data(map_data)

func _on_map_display_map_changed():
	var map_entity_representations = map_display.get_map_entity_representations()
	var selectable_power_poles_assigner = map_entity_representations.filter(func(representation: Node): return representation is SelectablePowerPole)
	var selectable_power_poles: Array[SelectablePowerPole]
	
	selectable_power_poles.assign(selectable_power_poles_assigner)
	
	for selectable_power_pole: SelectablePowerPole in selectable_power_poles:
		if !selectable_power_pole.pressed.is_connected(_on_selectable_power_pole_selected):
			selectable_power_pole.pressed.connect(_on_selectable_power_pole_selected.bind(selectable_power_pole))

func _on_selectable_power_pole_selected(selectable_power_pole: SelectablePowerPole) -> void:
	_update_selected_power_pole(selectable_power_pole)

func _update_selected_power_pole(new_selectable_power_pole: SelectablePowerPole) -> void:
	if _selected_power_pole:
		_selected_power_pole.deselect()
	_selected_power_pole = new_selectable_power_pole
	_selected_power_pole.select()
	
	confirm_button.disabled = not _selected_power_pole

func _on_confirm_button_pressed():
	power_pole_selected.emit(_selected_power_pole)
