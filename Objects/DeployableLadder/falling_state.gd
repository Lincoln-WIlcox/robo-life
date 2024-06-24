extends State

@export var character: CharacterBody2D
@export var deploying_state: State

func run():
	if character.is_on_floor():
		state_ended.emit(deploying_state)
