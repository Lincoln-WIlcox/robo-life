extends State

@export var character: CharacterBody2D
@export var retracted_state: State

func run():
	if character.is_on_floor():
		state_ended.emit(retracted_state)
