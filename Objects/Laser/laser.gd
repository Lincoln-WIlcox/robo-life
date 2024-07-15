extends Node2D

const SHAPE_OFFSET = 2.5

@onready var raycast: RayCast2D = $RayCast2D
@onready var collision_shape: CollisionShape2D = $DamageArea/CollisionShape2D
@onready var line: Line2D = $Line2D

@export var maximum_length := 750

func _ready():
	raycast.target_position.x = maximum_length

func _physics_process(delta):
	var laser_end_position: Vector2 = raycast.get_collision_point() if raycast.is_colliding() else raycast.target_position + raycast.global_position
	collision_shape.global_position = laser_end_position
	line.set_point_position(1, laser_end_position - line.global_position)
