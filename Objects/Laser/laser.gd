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

func update() -> void:
	raycast.force_raycast_update()
	_update_collision()
	_update_visuals()

func _physics_process(_delta):
	_update_collision()

func _process(_delta):
	_update_visuals()

func _update_collision() -> void:
	var laser_end_position: Vector2 = _get_laser_end_position()
	
	raycast.set_collision_mask_value(Utils.COLLISION_LAYERS.OneWayPlatforms, _rotated_target_position().y >= 0)
	
	collision_shape.global_position = laser_end_position
	collision_shape.position.x -= SHAPE_OFFSET

func _update_visuals() -> void:
	var laser_end_position: Vector2 = _get_laser_end_position()
	line.set_point_position(1, laser_end_position - line.global_position)
	line.global_rotation = 0

func _get_laser_end_position() -> Vector2:
	return raycast.get_collision_point() if raycast.is_colliding() else (_rotated_target_position()) + raycast.global_position

func _rotated_target_position() -> Vector2:
	return raycast.target_position.rotated(raycast.global_rotation)
