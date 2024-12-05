class_name MapTexture
extends MapEntity

##Displays a texture on the map. Set [member get_position] to a callable that returns what the position should be. Emit [signal update_sprite] whenever any variable of the sprite should change.

##Set this to a callable returing a Vector2, representing the local position of the node.
var get_position: Callable
##The texture to be displayed. Corresponds to the sprite's texture.
@export var display_texture: Texture:
	set(new_value):
		display_texture = new_value
		update_sprite.emit()
##Corresponds to the sprite's z_index.
@export var z_index: int = 0:
	set(new_value):
		z_index = new_value
		update_sprite.emit()
##Corresponds to the sprite's scale.
@export var scale: Vector2 = Vector2.ONE:
	set(new_value):
		scale = new_value
		update_sprite.emit()

##When emitted, members of the sprite will be updated to reflect the members of the map texture.
signal update_sprite
