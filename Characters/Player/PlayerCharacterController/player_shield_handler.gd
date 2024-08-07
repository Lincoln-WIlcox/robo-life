extends Node

@export var shield: Shield
@export var shield_rotation_pivot: Node2D
var just_started_shielding: Callable = func(): return false
var just_stopped_shielding: Callable = func(): return true
var player_character: CharacterBody2D

func _physics_process(delta):
	if just_started_shielding.call():
		shield.deploy()
	if just_stopped_shielding.call():
		shield.un_deploy()
	shield_rotation_pivot.look_at(MouseArea.global_position)
	shield_rotation_pivot.global_position = player_character.global_position
