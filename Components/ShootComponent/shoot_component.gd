class_name ShootComponent
extends Node

@export var bullet_packed_scene: PackedScene
@export var node_to_put_bullets_in: Node

func shoot(at: Vector2, from: Vector2, ignore_node: Node = null) -> Bullet:
	var bullet: Bullet = bullet_packed_scene.instantiate()
	bullet.global_position = from
	node_to_put_bullets_in.add_child(bullet)
	bullet.look_at(at)
	bullet.ignore_node = ignore_node
	return bullet
