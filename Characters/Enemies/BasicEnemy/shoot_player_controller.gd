extends Node

@onready var timer: Timer = $Timer

@export var bullet_packed_scene: PackedScene
@export var character: CharacterBody2D

var node_to_put_bullets_in: Node
var target := Vector2.ZERO

func _physics_process(delta):
	print(target)

func _on_timer_timeout():
	_shoot_bullet()

func _shoot_bullet():
	var bullet: Bullet = bullet_packed_scene.instantiate()
	bullet.global_position = character.global_position
	node_to_put_bullets_in.add_child(bullet)
	bullet.look_at(target)
	bullet.ignore_node = character
