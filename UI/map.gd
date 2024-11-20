class_name Map
extends Control

@onready var map_display: MapDisplay = $MapDisplay

func display_map_data(map_data: MapData) -> void:
	map_display.display_map_data(map_data)
