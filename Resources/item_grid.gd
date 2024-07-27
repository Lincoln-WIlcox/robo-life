class_name ItemGrid
extends Resource

##Used to represent a grid with items in it.

@export var size: Vector2i = Vector2i(6,4)
@export var initial_items: Array[ItemGridItem]:
	set(new_value):
		initial_items = new_value
		_items = initial_items

var _items: Array[ItemGridItem]

##Add an [ItemData] to the grid at the first position that works.
##The item will not be added to the grid if there is not space.
##Returns true if the item was added to the grid, returns false if it fails.
func add_item(item_data: ItemData) -> bool:
	var item_grid_item = item_can_be_added(item_data)
	if item_grid_item:
		_items.append(item_grid_item)
		emit_changed()
		return true
	return false

##Add an [ItemData] to the grid at the given position.
##The item will not be added to the grid if there is not space at the given position.
##Returns true if the item was added to the grid, returns false if it fails.
func add_item_at_position(item_data: ItemData, position: Vector2i) -> bool:
	var new_item_grid_item: ItemGridItem = ItemGridItem.new(item_data, position)
	
	if not item_grid_item_can_be_added(new_item_grid_item):
		return false
	
	_items.append(new_item_grid_item)
	emit_changed()
	return true

##Add a [ItemGridItem] to the grid.
##The item will not be added to the grid if there is not space at the grid item's position.
##Returns true if the item was added to the grid, returns false if it fails.
func add_grid_item(grid_item: ItemGridItem) -> bool:
	if item_grid_item_can_be_added(grid_item):
		_items.append(grid_item)
		emit_changed()
		return true
	return false

##Returns true if this item grid contains the passed item
func has_item(item_data: ItemData) -> bool:
	for item_grid_item: ItemGridItem in _items:
		if item_grid_item.item_data == item_data:
			return true
	return false

##Removes the first occurrence of an item in a grid
func remove_item(item_data: ItemData) -> void:
	for item_grid_item: ItemGridItem in _items:
		if item_grid_item.item_data == item_data:
			_items.erase(item_grid_item)
			emit_changed()
			return
	push_warning("item_data not in _items.")

func remove_grid_item(grid_item: ItemGridItem) -> void:
	_items.erase(grid_item)
	emit_changed()

func remove_index(index: int) -> void:
	_items.remove_at(index)
	emit_changed()

##Returns the [ItemData] for each item in the grid.
func get_items() -> Array[ItemData]:
	var return_items: Array[ItemData]
	var item_datas := _items.map(func(item: ItemGridItem): return item.item_data)
	return_items.assign(item_datas)
	return return_items

##Returns the grid items.
func get_grid_items() -> Array[ItemGridItem]:
	return _items

##Returns false if there is no space for the item. Returns the item grid item for the first spot where it can fit if there is space.
func item_can_be_added(item_data: ItemData):
	var new_item_grid_item: ItemGridItem = ItemGridItem.new(item_data, Vector2i(0, 0))
	
	#if the size of the grid item is greater than the size of the grid, return false
	if size.y - new_item_grid_item.item_data.grid_size.x < 0 or size.x - new_item_grid_item.rect.size.y < 0:
		return false
	
	for y: int in range(0, size.y - new_item_grid_item.rect.size.y + 1):
		for x: int in range(0, size.x - new_item_grid_item.rect.size.x + 1):
			new_item_grid_item.position = Vector2i(x, y)
			
			if item_grid_item_can_be_added(new_item_grid_item):
				return new_item_grid_item
	
	return false

func item_grid_item_can_be_added(item_grid_item: ItemGridItem) -> bool:
	if not (item_grid_item.position.x >= 0 or item_grid_item.position.y >= 0 or item_grid_item.rect.end.x <= size.x or item_grid_item.rect.end.y <= size.y):
		return false
	for existing_item: ItemGridItem in _items:
		if existing_item.rect.intersects(item_grid_item.rect) and existing_item != item_grid_item:
			return false
	return true
