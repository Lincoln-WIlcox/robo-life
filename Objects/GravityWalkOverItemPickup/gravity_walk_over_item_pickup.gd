extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var pickup_area = $WalkOverItemPickupArea
@export var speed := 200

func _ready():
	velocity_component.velocity = Vector2(speed, 0).rotated(randf_range(0, 2 * PI))
	pickup_area.make_inventory_addition_unique()
	pickup_area.inventory_addition.reached_zero.connect(_on_inventory_addition_reached_zero)

func _physics_process(_delta):
	if not is_on_floor():
		velocity_component.update()

func _on_inventory_addition_reached_zero():
	queue_free()
