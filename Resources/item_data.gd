class_name ItemData
extends Resource

@export var texture: Texture
@export var name: String
@export var grid_size: Vector2 = Vector2(1,1):
	set(new_value):
		assert(new_value.x > 0 and new_value.y > 0, "grid size cannot be 0 or less than 0 on either axis.")
		grid_size = new_value
##by default, an item pickup will be spawned with this item data when this item is dropped. Set this to a scene you'd like to appear instead.
@export_file var drop_scene: String
