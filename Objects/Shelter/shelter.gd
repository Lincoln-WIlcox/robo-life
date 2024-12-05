extends Node2D

@export var level_map_map_entity_injector: MapEntityInjector
@export var map_scene: MapScene

func _ready():
	level_map_map_entity_injector.add_map_entity(map_scene)

func _physics_process(delta):
	if map_scene.scene_is_setup():
		map_scene.instance.position = global_position
