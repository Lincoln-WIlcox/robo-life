class_name ItemData
extends Resource

@export var texture: Texture
@export var name: String

##by default, an item pickup will be spawned with this item data when this item is dropped. Set this to a scene you'd like to appear instead.
@export var drop_scene: PackedScene
