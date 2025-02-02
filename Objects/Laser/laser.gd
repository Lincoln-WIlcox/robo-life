@tool
class_name Laser
extends Node2D

const SHAPE_OFFSET = 1

@onready var raycast: RayCast2D = $RayCast2D
@onready var collision_shape: CollisionShape2D = $HeatArea/CollisionShape2D
@onready var line: Line2D = $Line2D
@onready var heat_area: HeatArea = $HeatArea

@export var maximum_length := 750:
	set(new_value):
		if is_node_ready():
			raycast.target_position.x = maximum_length
		maximum_length = new_value
@export var heat_amount := 1:
	set(new_value):
		if is_node_ready():
			heat_area.heat_amount = new_value
		heat_amount = new_value

func _ready():
	raycast.target_position.x = maximum_length
	heat_area.heat_amount = heat_amount
	raycast.add_exception(heat_area)

func _enter_tree():
	if !is_node_ready():
		await ready
	
	#for two frames after entering tree the raycast does not collide, even if you call raycast.force_raycast_update(). we can do a manual query for the second frame, but not the first.
	line.hide()
	heat_area.set_collision_layer_value(Utils.COLLISION_LAYERS.Heat, false)
	await Engine.get_main_loop().physics_frame
	if is_inside_tree():
		line.show()
		_do_manual_update()
		heat_area.set_collision_layer_value(Utils.COLLISION_LAYERS.Heat, true)
		await Engine.get_main_loop().physics_frame

func _do_manual_update() -> void:
	var result = _raycast_query()
	
	if result:
		var laser_end_position: Vector2 = result.position
		
		_set_collision_end(laser_end_position)
		_set_visuals_end_position(laser_end_position)
	else:
		_update_collision()
		_update_visuals()

#func update() -> void:
	#raycast.force_raycast_update()
	#_update_collision()
	#_update_visuals()

func _physics_process(_delta):
	_update_collision()

func _process(_delta):
	_update_visuals()

func _update_collision() -> void:
	var laser_end_position: Vector2 = _get_laser_end_position()
	_set_collision_end(laser_end_position)

func _update_visuals() -> void:
	var laser_end_position: Vector2 = _get_laser_end_position()
	_set_visuals_end_position(laser_end_position)

func _set_collision_end(at_position: Vector2) -> void:
	raycast.set_collision_mask_value(Utils.COLLISION_LAYERS.OneWayPlatforms, _rotated_target_position().y >= 0)
	
	collision_shape.global_position = at_position
	collision_shape.position.x -= SHAPE_OFFSET

func _set_visuals_end_position(at_position: Vector2) -> void:
	line.set_point_position(1, at_position - line.global_position)
	line.global_rotation = 0

func _get_laser_end_position() -> Vector2:
	return raycast.get_collision_point() if raycast.is_colliding() else (_rotated_target_position()) + raycast.global_position

func _rotated_target_position() -> Vector2:
	return raycast.target_position.rotated(raycast.global_rotation)

#returns a Vector2 if 
func _raycast_query() -> Dictionary:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(raycast.global_position, _rotated_target_position())
	#query.exclude = []
	query.set_hit_from_inside(true)
	query.set_collide_with_areas(true)
	query.set_collide_with_bodies(true)
	
	return space_state.intersect_ray(query)
