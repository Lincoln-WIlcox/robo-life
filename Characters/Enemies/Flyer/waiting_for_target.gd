extends State

const CHASE_DISTANCE = 320

@export var to_player_raycast: RayCast2D
@export var character: CharacterBody2D
@export var chasing_target_state: State

var target: Target

func run():
	to_player_raycast.target_position = target.global_position - to_player_raycast.global_position
	
	print(character.global_position.distance_to(target.global_position))
	
	if not to_player_raycast.is_colliding() and character.global_position.distance_to(target.global_position) < CHASE_DISTANCE:
		state_ended.emit(chasing_target_state)
