@tool
extends Node2D

const SHAPE_OFFSET = 2

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

func _physics_process(delta):
	var laser_end_position: Vector2 = raycast.get_collision_point() if raycast.is_colliding() else (raycast.target_position.rotated(raycast.global_rotation)) + raycast.global_position
	collision_shape.global_position = laser_end_position
	collision_shape.position.x -= SHAPE_OFFSET

func _process(delta):
	var laser_end_position: Vector2 = raycast.get_collision_point() if raycast.is_colliding() else (raycast.target_position.rotated(raycast.global_rotation)) + raycast.global_position
	line.set_point_position(1, laser_end_position - line.global_position)
	line.global_rotation = 0
