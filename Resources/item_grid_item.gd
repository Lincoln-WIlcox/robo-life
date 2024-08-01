class_name ItemGridItem
extends Resource

##Used by [ItemGrid]

@export var item_data: ItemData
@export var position: Vector2i
var rect: Rect2i:
	get:
		return Rect2i(position, item_data.grid_size)

func _init(_item_data = null, _position = null):
	if _item_data != null:
		item_data = _item_data
	if _position != null:
		position = _position
