extends Node

@export var deployable_ladder_packed_scene: PackedScene
@export var player_character: PlayerCharacter

func _input(event):
	
	if event.is_action_pressed("spawn_deployable_ladder"):
		var deployable_ladder = deployable_ladder_packed_scene.instantiate()
		deployable_ladder.position = Vector2(player_character.character.global_position.x - 32, player_character.character.global_position.y - 32)
		add_child(deployable_ladder)
