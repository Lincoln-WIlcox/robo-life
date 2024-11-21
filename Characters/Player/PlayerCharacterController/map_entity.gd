extends MapEntity

@export var player_character: PlayerCharacter

func _physics_process(delta):
	global_position = player_character.character.global_position
