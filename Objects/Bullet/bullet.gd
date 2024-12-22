class_name Bullet
extends Node2D

@onready var marker = $Marker2D
@onready var visible_on_screen_notifier = $Marker2D/VisibleOnScreenNotifier2D

@export var speed := 5
@export var direction: float = 0:
	set(new_value):
		rotation_degrees = new_value
	get:
		return rotation_degrees

@export var ignore_node: Node

#func _ready():
	#if not visible_on_screen_notifier.is_on_screen():
		#destroy()

func _physics_process(_delta):
	marker.position.x += speed

func _on_hitbox_body_entered(body):
	if body != ignore_node:
		destroy()

func _on_hitbox_area_entered(area):
	if area != ignore_node:
		destroy()

func destroy():
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy()
