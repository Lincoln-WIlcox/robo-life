extends Node

@export var player_character: PlayerCharacter
@export var laser_gun: LaserGun

func _physics_process(delta):
	laser_gun.global_position = player_character.character.global_position
