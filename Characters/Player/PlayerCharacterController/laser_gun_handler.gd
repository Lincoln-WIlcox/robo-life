extends Node2D

@export var player_character: PlayerCharacter
@export var laser_gun: LaserGun

var is_firing: Callable

func _physics_process(delta):
	laser_gun.global_position = player_character.character.global_position
	laser_gun.look_at(get_global_mouse_position())

func update_firing():
	laser_gun.firing = is_firing.call()
