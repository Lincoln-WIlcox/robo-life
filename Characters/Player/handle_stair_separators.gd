extends Node

const FLAT_FLOOR_MARGIN = 2

@export var character: CharacterBody2D
@export var climb_stairs_left: CollisionShape2D
@export var climb_stairs_right: CollisionShape2D

func _physics_process(delta):
	if character.is_on_floor() and rad_to_deg(character.get_floor_normal().angle()) > -90 - FLAT_FLOOR_MARGIN and rad_to_deg(character.get_floor_normal().angle()) < -90 + FLAT_FLOOR_MARGIN:
		climb_stairs_left.disabled = false
		climb_stairs_right.disabled = false
	else:
		climb_stairs_left.disabled = true
		climb_stairs_right.disabled = true
