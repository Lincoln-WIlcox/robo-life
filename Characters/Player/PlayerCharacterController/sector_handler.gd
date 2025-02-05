extends Node

#the radius around the player that sectors will get revealed when they go within
@export var reveal_radius: float = 128

var player_body: CharacterBody2D
var get_revealed_sectors: Callable
var reveal_sector: Callable

signal sector_revealed(sector_coords: Vector2i)

func _physics_process(delta):
	var sector_coords: Vector2i = Utils.get_sector_coords_at(player_body.global_position)
	
	var sector_visited: bool = get_revealed_sectors.call().has(sector_coords)
	
	if not sector_visited:
		_reveal_sector(sector_coords)
	
	#orthogonally surrounding sectors are checked for proximity.
	
	var left_sector_coords: Vector2i = Vector2i(sector_coords.x - 1, sector_coords.y)
	var left_sector_bounds: Rect2 = Utils.get_global_sector_bounds(left_sector_coords)
	var left_sector_right_edge: float = left_sector_bounds.position.x + left_sector_bounds.size.x
	if abs(player_body.global_position.x - left_sector_right_edge) <= reveal_radius:
		_reveal_sector(left_sector_coords)
	
	var upper_sector_coords: Vector2i = Vector2i(sector_coords.x, sector_coords.y - 1)
	var upper_sector_bounds: Rect2 = Utils.get_global_sector_bounds(upper_sector_coords)
	var upper_sector_bottom_edge: float = upper_sector_bounds.position.y + upper_sector_bounds.size.y
	if abs(player_body.global_position.y - upper_sector_bottom_edge) <= reveal_radius:
		_reveal_sector(upper_sector_coords)
	
	var right_sector_coords: Vector2i = Vector2i(sector_coords.x + 1, sector_coords.y)
	var right_sector_bounds: Rect2 = Utils.get_global_sector_bounds(right_sector_coords)
	var right_sector_left_edge: float = right_sector_bounds.position.x
	if abs(player_body.global_position.x - right_sector_left_edge) <= reveal_radius:
		_reveal_sector(right_sector_coords)
	
	var lower_sector_coords: Vector2i = Vector2i(sector_coords.x, sector_coords.y + 1)
	var lower_sector_bounds: Rect2 = Utils.get_global_sector_bounds(lower_sector_coords)
	var lower_sector_upper_edge: float = lower_sector_bounds.position.y
	if abs(player_body.global_position.y - lower_sector_upper_edge) <= reveal_radius:
		_reveal_sector(lower_sector_coords)

func _reveal_sector(sector_coords: Vector2i) -> void:
	reveal_sector.call(sector_coords)
	sector_revealed.emit(sector_coords)
#
#func _get_surrounding_sectors(sector_coords: Vector2i) -> Array[Vector2i]:
	#var surrounding_sectors: Array[Vector2i] = [
		#Vector2i(sector_coords.x - 1, sector_coords.y),
		#Vector2i(sector_coords.x, sector_coords.y - 1),
		#Vector2i(sector_coords.x + 1, sector_coords.y),
		#Vector2i(sector_coords.x, sector_coords.y + 1)
	#]
	#
	#return surrounding_sectors
