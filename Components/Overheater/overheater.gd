class_name Overheater
extends Node2D

@onready var heat_receiver = $HeatReceiver

@export var max_heat := 1000.0
@export var cooldown_rate := 1.0

var heat := 0.0
var overheated := false:
	set(new_value):
		if not overheated and new_value:
			max_heat_reached.emit()
		overheated = new_value

signal max_heat_reached

func _ready():
	var collision_shapes: Array[Node] = get_children().filter(func(c: Node): return c is CollisionShape2D)
	if collision_shapes.size() == 0:
		push_warning("There are no CollisionShape2Ds as child of Overheater. It cannot interact with heaters.")
	for collision_shape: CollisionShape2D in collision_shapes:
		remove_child(collision_shape)
		heat_receiver.add_child(collision_shape)

func _physics_process(_delta):
	heat += heat_receiver.receiving_heat if heat_receiver.receiving_heat else -cooldown_rate
	heat = max(heat, 0)
	overheated = heat >= max_heat
