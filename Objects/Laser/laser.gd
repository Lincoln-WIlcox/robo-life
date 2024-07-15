extends Node2D

const SHAPE_OFFSET = 2.5

@onready var raycast: RayCast2D = $RayCast2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

@export var maximum_length := 750

func _ready():
	raycast.target_position.x = maximum_length

func _physics_process(delta):
	var length = (raycast.get_collision_point() - raycast.get_global_transform().origin).length() if raycast.is_colliding() else raycast.target_position.x
	#doing times 3 so the collision shape goes into the area a little bit so it can detect it.
	collision_shape.shape.size.x = length + (SHAPE_OFFSET * 3)
	collision_shape.position.x = length / 2 - SHAPE_OFFSET
