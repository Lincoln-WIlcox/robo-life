extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@export var speed := 200

func _ready():
	velocity_component.velocity = Vector2(speed, 0).rotated(randf_range(0, 2 * PI))

func _on_walk_over_item_pickup_area_collected():
	queue_free()
