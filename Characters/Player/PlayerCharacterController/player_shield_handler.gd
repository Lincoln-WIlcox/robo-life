extends Node

@export var shield: Shield
@export var shield_rotation_pivot: Node2D
var just_started_shielding: Callable = func(): return false
var just_stopped_shielding: Callable = func(): return true
var player_character: CharacterBody2D
var shield_progress_bar: ProgressBar:
	set(new_value):
		shield_progress_bar = new_value
		shield_progress_bar.max_value = shield.max_energy

func _physics_process(delta):
	shield_progress_bar.value = shield.energy
	if shield.energy == 0:
		shield_progress_bar.hide()
	else:
		shield_progress_bar.show()
	if just_started_shielding.call():
		shield.deploy()
	if just_stopped_shielding.call():
		shield.un_deploy()
	shield_rotation_pivot.look_at(MouseArea.global_position)
	shield_rotation_pivot.global_position = player_character.global_position
