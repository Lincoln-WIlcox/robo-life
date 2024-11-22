class_name OneWayPlatform
extends StaticBody2D

@export var map_texture: MapTexture

func _ready():
	map_texture.get_position = func(): return global_position

func get_map_entity() -> MapTexture:
	return map_texture
