class_name GravityComponent
extends Node

const MARGIN_FOR_NO_SLIDE = 80
##Used to apply gravity to velocity components.

##The velocity component that gravity will be applied to.
@export var velocity_component: VelocityComponent
##The character that gravity will be applied to.
##Used to check for wall normals.
@export var character: CharacterBody2D

@export_group("Variables")
##Will apply gravity to given velocity component while true.
@export var active := true
##If this is checked, the component will use the [member GravityComponent.custom_gravity_speed] and [member GravityComponent.custom_gravity_direction] values instead of the default values. [br]
##The default values are defined in project settings ([code]physics/2d/default_gravity[/code] and [code]physics/2d/default_gravity_vector[/code]).
@export var use_custom_gravity := false
##The speed at which [member GravityComponent.affecting_node] will fall while [member GravityComponent.use_custom_gravity] is true.
@export var custom_gravity_speed := 32
##The direction in which [member GravityComponent.affecting_node] will fall while [member GravityComponent.use_custom_gravity] is true.
@export var custom_gravity_direction := Vector2(0,1)
##The maximum downward speed [member GravityComponent.affecting_node] can have before this stops applying gravity. Set to 0 to have no limit.
@export var terminal_speed := 1000

var _gravity_direction: Vector2:
	get:
		if use_custom_gravity:
			return custom_gravity_direction
		else:
			return ProjectSettings.get_setting("physics/2d/default_gravity_vector")

var _gravity_speed: int:
	get:
		if use_custom_gravity:
			return custom_gravity_speed
		else:
			return ProjectSettings.get_setting("physics/2d/default_gravity")

#var _is_on_slope = false

func _physics_process(_delta):
	if active:
		_apply_gravity()

func _apply_gravity() -> void:
	if !character.is_on_floor() and (velocity_component.velocity.y < terminal_speed or terminal_speed == 0):
		velocity_component.accelerate_in_direction_at_full_speed_at_rate(_gravity_direction, _gravity_speed)
