extends Node

@onready var timer = $ClimbBuffer

@export var interact_area: Area2D
@export var character: CharacterBody2D

signal climbable_climbed(area: ClimbableArea)
signal climbable_left(area: ClimbableArea)

var is_climbing := func(): return false
var is_moving_down := func(): return false

func get_climbable() -> ClimbableArea:
	var climbable_areas = interact_area.get_overlapping_areas().filter(func(area): return area is ClimbableArea)
	
	if climbable_areas.size() > 0:
		return climbable_areas.reduce(
		func(lowest_distance_area: ClimbableArea, area: ClimbableArea):
			var distance_from_area_to_character = abs(area.global_position.x - character.global_position.x)
			var distance_from_lowest_to_character = abs(lowest_distance_area.global_position.x - character.global_position.x)
			if distance_from_area_to_character < distance_from_lowest_to_character:
				return area
			else:
				return lowest_distance_area
		, climbable_areas[0])
	return null

func _on_interact_area_area_entered(area):
	if area is ClimbableArea and !timer.is_stopped() and is_climbing.call() and _climbable_can_be_climbed(area):
		climbable_climbed.emit(area)

func _on_interact_area_area_exited(area):
	if area is ClimbableArea:
		climbable_left.emit(area)

func _on_player_character_just_climbed():
	var climbable = get_climbable()
	
	if _climbable_can_be_climbed(climbable):
		climbable_climbed.emit(climbable)
	timer.start()

func _climbable_can_be_climbed(climbable: ClimbableArea):
	return climbable != null and not (climbable.top_of_climbable - Utils.HIGHEST_LADDER_OFFSET > character.global_position.y and not is_moving_down.call())
