extends Node

var revealed_sectors: Array[Vector2i]

func reveal_sector(sector_coords: Vector2i) -> void:
	revealed_sectors.append(sector_coords)
