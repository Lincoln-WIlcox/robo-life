extends Node2D

@export var level_map_map_entity_injector: MapEntityInjector
@export var map_scene: MapScene

func _ready():
	level_map_map_entity_injector.add_map_entity(map_scene)
	map_scene.scene_setup.connect(_set_map_entity_position)

func _set_map_entity_position() -> void:
	map_scene.instance.position = global_position
