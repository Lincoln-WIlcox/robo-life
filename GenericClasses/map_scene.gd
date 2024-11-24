class_name MapScene
extends MapEntity

@export var packed_scene: PackedScene
var instance: Node

func setup_scene():
	instance = packed_scene.instantiate()
