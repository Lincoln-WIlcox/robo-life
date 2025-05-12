extends Node

const AGGRO_RANGE = 300

@export var turret: Turret
@export var target: Target
@export var raycast: RayCast2D

signal aggro_gained
signal aggro_lost

var has_aggro: bool = false

func _physics_process(delta):
	if not has_aggro and not raycast.is_colliding() and turret.global_position.distance_to(target.global_position) < AGGRO_RANGE:
		has_aggro = true
		aggro_gained.emit()
	elif has_aggro and (raycast.is_colliding() or turret.global_position.distance_to(target.global_position) > AGGRO_RANGE):
		has_aggro = false
		aggro_lost.emit()
