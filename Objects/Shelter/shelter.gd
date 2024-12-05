extends Node2D

@export var level_map_map_entity_injector: MapEntityInjector
@export var map_scene: MapScene

func _ready():
	map_scene.setup_scene()
	level_map_map_entity_injector.add_map_entity(map_scene)

func _physics_process(delta):
	map_scene.instance.position = global_position
