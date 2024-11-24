class_name MapTexture
extends MapEntity

@export var display_texture: Texture:
	set(new_value):
		display_texture = new_value
		update_sprite.emit()
@export var z_index: int = 0:
	set(new_value):
		z_index = new_value
		update_sprite.emit()
@export var scale: Vector2 = Vector2.ONE:
	set(new_value):
		scale = new_value
		update_sprite.emit()

signal update_sprite
