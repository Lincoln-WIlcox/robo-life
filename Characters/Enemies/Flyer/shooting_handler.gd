extends Node

@export var bullet_packed_scene: PackedScene
@export var character: CharacterBody2D

var node_to_put_bullets_in: Node
var target: Target

func shoot_bullet():
	var bullet: Bullet = bullet_packed_scene.instantiate()
	bullet.global_position = character.global_position
	node_to_put_bullets_in.add_child(bullet)
	bullet.look_at(target.global_position)
	bullet.ignore_node = character
