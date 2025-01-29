extends State

const HIGHEST_LADDER_OFFSET = 8

var is_moving_up: Callable
var is_moving_down: Callable
var is_climbing: Callable
var just_jumped: Callable

@export var jumping_state: State
@export var falling_state: State
@export var standing_state: State
@export var character: CharacterBody2D
@export var one_way_detector: Area2D
@export var climbing_rope_detector: Node
@export var gravity_component: GravityComponent
@export var horizontal_movement_component: HorizontalMovementComponent
@export var velocity_component: VelocityComponent
@export var bottom_of_player: Marker2D
@export var upward_climb_speed := 180
@export var downward_climb_speed := 400
@export var climb_accel := 35

var _just_climbed = false
var _climbable: ClimbableArea

func enter():
	_climbable = climbing_rope_detector.get_climbable()
	
	gravity_component.active = false
	
	velocity_component.velocity.x = 0
	
	character.set_collision_mask_value(Utils.COLLISION_LAYERS.OneWayPlatforms, false)
	character.global_position.x = _climbable.global_position.x
	
	_just_climbed = true

func run():
	character.global_position.x = _climbable.global_position.x
	var target_y = 0
	
	if is_moving_up.call() and character.global_position.y > _climbable.top_of_climbable - HIGHEST_LADDER_OFFSET:
		target_y -= upward_climb_speed
	if is_moving_down.call() and bottom_of_player.global_position.y < _climbable.bottom_of_climbable:
		target_y += downward_climb_speed
	elif character.global_position.y <= _climbable.top_of_climbable - HIGHEST_LADDER_OFFSET and not _character_touching_one_way():
		character.global_position.y = _climbable.top_of_climbable - HIGHEST_LADDER_OFFSET
		velocity_component.velocity.y = max(velocity_component.velocity.y, 0)
	elif bottom_of_player.global_position.y >= _climbable.bottom_of_climbable:
		character.global_position.y = _climbable.bottom_of_climbable - bottom_of_player.position.y
		velocity_component.velocity.y = min(velocity_component.velocity.y, 0)
	
	velocity_component.accelerate_y_to_velocity_at_rate(target_y, climb_accel)
	
	if !is_climbing.call():
		_just_climbed = false
	
	if just_jumped.call():
		pass
	
	if just_jumped.call() and not _just_climbed:
		state_ended.emit(jumping_state)
	if character.is_on_floor() and is_moving_down.call():
		state_ended.emit(standing_state)

func exit():
	gravity_component.active = true
	character.set_collision_mask_value(Utils.COLLISION_LAYERS.OneWayPlatforms, true)

func _on_climbing_rope_detector_climbable_left(area: ClimbableArea):
	if is_current_state.call() and area == _climbable:
		state_ended.emit(falling_state)

func _character_touching_one_way():
	var areas = one_way_detector.get_overlapping_bodies()
	return areas.size() > 0
