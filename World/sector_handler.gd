extends Node

var revealed_sectors: Array[Vector2i]

signal sector_revealed(sector_coords: Vector2i)

func reveal_sector(sector_coords: Vector2i) -> void:
	revealed_sectors.append(sector_coords)
	sector_revealed.emit(sector_coords)
