class_name ItemGridItem
extends Resource

##Used by [ItemGrid]

@export var item_data: ItemData
@export var position: Vector2
var rect: Rect2i:
	get:
		return Rect2i(position, item_data.grid_size)

func _init(_item_data: ItemData, _position: Vector2):
	item_data = _item_data
	position = _position
