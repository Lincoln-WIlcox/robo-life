extends Control

@onready var map_display: MapDisplay = $ContentDivider/MapDisplay
@export var map_data: MapData

func _ready():
	map_display.display_map_data(map_data)
