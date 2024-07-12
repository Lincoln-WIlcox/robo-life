extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@export var speed := 200

func _ready():
	velocity_component.velocity = Vector2(speed, 0).rotated(randf_range(0, 2 * PI))

func _physics_process(delta):
	if not is_on_floor():
		velocity_component.update()

func _on_walk_over_item_pickup_area_collected():
	queue_free()
