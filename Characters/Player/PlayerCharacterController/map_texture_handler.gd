extends Node

var map_texture: MapTexture

func _on_timer_timeout():
	map_texture.emit_changed()
