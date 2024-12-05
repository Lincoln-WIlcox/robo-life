##Allows you to instance a scene within a map.

class_name MapScene
extends MapEntity

##The scene to be instanced.
@export var packed_scene: PackedScene
##The instance on the map.
var instance: Node

##Called when the map is set up if instance is null. You can call it earlier to set up the scene.
func setup_scene() -> void:
	instance = packed_scene.instantiate()

func scene_is_setup() -> bool:
	return instance != null
