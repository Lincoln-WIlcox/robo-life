extends Node

var player_body: CharacterBody2D
var get_revealed_sectors: Callable
var reveal_sector: Callable

signal sector_revealed(sector_coords: Vector2i)

func _physics_process(delta):
	var sector_coords: Vector2i = Utils.get_sector_coords_at(player_body.global_position)
	
	var sector_visited: bool = get_revealed_sectors.call().has(sector_coords)
	
	if not sector_visited:
		reveal_sector.call(sector_coords)
		sector_revealed.emit(sector_coords)
