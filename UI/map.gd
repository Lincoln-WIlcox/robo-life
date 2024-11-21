class_name Map
extends Control

@onready var map_display: MapDisplay = $MapDisplay

func display_map_data(map_data: MapData) -> void:
	if not is_node_ready():
		await ready
	map_display.display_map_data(map_data)
