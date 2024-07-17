extends Node2D

@onready var heat_receiver = $DamageReceiver

@export var max_heat := 1000
@export var cooldown_rate := 1

var heat = 0

signal max_heat_reached

func _ready():
	var collision_shapes: Array[Node2D] = get_children().filter(func(c: Node): return c is CollisionShape2D)
	for collision_shape: CollisionShape2D in collision_shapes:
		remove_child(collision_shape)
		heat_receiver.add_child(collision_shape)

func _physics_process(delta):
	heat += heat_receiver.receiving_damage if heat_receiver.receiving_damage else -cooldown_rate
	heat = max(heat, 0)
