class_name DustSpawner
extends Node

@export var dust_packed_scene: PackedScene
@export var node_to_put_dust_in: Node

func create_dust(dust_position: Vector2) -> void:
	var dust: Node2D = dust_packed_scene.instantiate()
	dust.position = dust_position
	node_to_put_dust_in.add_child(dust)
