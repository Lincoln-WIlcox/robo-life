extends Target

@export var player_character_controller: PlayerCharacterController:
	set(new_value):
		player_character_controller = new_value
		if player_character_controller:
			if not player_character_controller.is_node_ready():
				await player_character_controller.ready
			following = player_character_controller.player_character.character
