class_name ItemGrid
extends Resource

##Used to represent a grid with items in it.

@export var size: Vector2i = Vector2i(6,4)

var _items: Array[ItemGridItem]

##Add an item to the grid at the first position that works.
##The item will not be added to the grid if there is not space.
##Returns true if the item was added to the grid, returns false if it fails.
func add_item(item_data: ItemData) -> bool:
	var new_item_grid_item: ItemGridItem = ItemGridItem.new(item_data, Vector2i(0, 0))
	
	for y: int in range(0, size.y):
		for x: int in range(0, size.x):
			new_item_grid_item.position = Vector2i(x, y)
			
			if _item_grid_item_can_be_placed(new_item_grid_item):
				_items.append(new_item_grid_item)
				return true
	
	return false

##Add an item to the grid at the given position.
##The item will not be added to the grid if there is not space at the given position.
##Returns true if the item was added to the grid, returns false if it fails.
func add_item_at_position(item_data: ItemData, position: Vector2i) -> bool:
	var new_item_grid_item: ItemGridItem = ItemGridItem.new(item_data, position)
	
	if not _item_grid_item_can_be_placed(new_item_grid_item):
		return false
	
	_items.append(new_item_grid_item)
	
	return true

##returns true if this item grid contains the passed item
func has_item(item_data: ItemData) -> bool:
	for item_grid_item: ItemGridItem in _items:
		if item_grid_item.item_data == item_data:
			return true
	return false

func remove_item(item_data: ItemData) -> void:
	for item_grid_item: ItemGridItem in _items:
		if item_grid_item.item_data == item_data:
			_items.erase(item_grid_item)
			return
	push_warning("item_data not in _items.")

func _item_grid_item_can_be_placed(item_grid_item: ItemGridItem) -> bool:
	for existing_item: ItemGridItem in _items:
		if existing_item.rect.intersects(item_grid_item.rect) and existing_item != item_grid_item:
			return false
	return true