extends Node

@export var shield: Shield
@export var shield_rotation_pivot: Node2D
@export var pickup_stuff_handler: Node
var just_started_shielding: Callable = func(): return false
var just_stopped_shielding: Callable = func(): return true
var player_character: CharacterBody2D
var shield_progress_bar: ProgressBar:
	set(new_value):
		shield_progress_bar = new_value
		shield_progress_bar.max_value = shield.max_energy

func _physics_process(_delta):
	shield_progress_bar.value = shield.energy
	if shield.energy == shield.max_energy:
		shield_progress_bar.hide()
	else:
		shield_progress_bar.show()
	if just_started_shielding.call() and not pickup_stuff_handler.just_started_picking_up:
		shield.deploy()
	if just_stopped_shielding.call():
		shield.un_deploy()
	shield_rotation_pivot.look_at(MouseArea.global_position)
	shield_rotation_pivot.global_position = player_character.global_position
