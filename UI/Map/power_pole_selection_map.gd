extends Control

@onready var map_display: MapDisplay = $ContentDivider/MapDisplay
@export var map_data: MapData

var _selectable_power_poles: Array[SelectablePowerPole]

func _ready():
	map_display.display_map_data(map_data)

func _on_map_display_map_changed():
	var map_entity_representations = map_display.get_map_entity_representations()
	var selectable_power_poles = map_entity_representations.filter(func(representation: Node): return representation is SelectablePowerPole)
	_selectable_power_poles.assign(selectable_power_poles)
