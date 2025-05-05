class_name Ledge
extends Area2D

##Used by the player to grab onto.

##The side of the platform this ledge is on.
@warning_ignore("enum_variable_without_default")
@export var grab_direction: Utils.GrabDirections
@export_flags_2d_physics var ledge_grab_obstruction_collision_layers: int

var is_left_side:
	get:
		return grab_direction == Utils.GrabDirections.LEFT
var is_right_side:
	get:
		return grab_direction == Utils.GrabDirections.RIGHT

##Returns true if the given Rect2 can fit on the ledge (there is no groud/solid entities in the given space). The position of [param space] will be relative to the ledge.
func can_fit_on_grab(shape: Shape2D, query_transform: Transform2D, layers: int = ledge_grab_obstruction_collision_layers) -> bool:
	#this does a manual query on the world to determine if there are any intersecting shapes.
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.collide_with_bodies = true
	query.shape = shape
	query.transform = query_transform
	query.collision_mask = layers
	var collision: Array[Dictionary] = space_state.intersect_shape(query, 1)
	
	return collision.size() == 0
