class_name Inventory
extends Resource

##Used to represent the batteries, steel, food and items a character or object holds

##The amount of batteries currently in the inventory
@export var batteries := 0:
	set(new_value):
		batteries = new_value
		
		emit_changed()
##The amount of steel currently in the inventory
@export var steel := 0:
	set(new_value):
		steel = new_value
		
		emit_changed()
##The initial amount of food
@export var initial_food := 0:
	set(new_value):
		if not _food:
			initial_food = new_value
			_food = initial_food
			emit_changed()
		else:
			push_warning("changing initial_food after creation of resource does nothing")
##The maximum amount of food this inventory can hold. Using [method change_food] will not allow food to go above this value
@export var max_food := 50:
	set(new_value):
		max_food = new_value
		
		emit_changed()
##The initial value for the item grid. The item grid itself is private. To interact with it, use the functions provided
@export var initial_item_grid: ItemGrid:
	set(new_value):
		if item_grid == null:
			item_grid = new_value

##This inventory's associated [ItemGrid]
var item_grid: ItemGrid = null:
	set(new_value):
		item_grid = new_value
		item_grid.changed.connect(func(): emit_changed())
		emit_changed()
var _food := initial_food

##Adds an item to the item grid
func add_item(item: ItemData) -> bool:
	if item_grid.add_item(item):
		emit_changed()
		return true
	return false

##Removes the first occurance of an item from the item grid
func remove_item(item: ItemData) -> void:
	item_grid.remove_item(item)
	emit_changed()

##Used primarily by [ItemGridInterface]. Removes a [GridItem] from the [member Inventory.item_grid]
func remove_grid_item(grid_item: ItemGridItem) -> void:
	item_grid.remove_grid_item(grid_item)
	emit_changed()

##Gets all the items in the item grid
func get_items() -> Array[ItemData]:
	return item_grid.get_items()

##Returns true if the item grid contains the given item
func has_item(item: ItemData) -> bool:
	return item_grid.has_item(item)

##Adds an [InventoryAddition] to the inventory. Anything the inventory takes is subtracted from [param inventory_addition]. If the inventory can't take something in an addition, it will only subtract what it can take from the inventory addition.
func add_addition(inventory_addition: InventoryAddition) -> void:
	batteries += inventory_addition.gain_batteries
	inventory_addition.gain_batteries = 0
	steel += inventory_addition.gain_steel
	inventory_addition.gain_steel = 0
	for item: ItemData in inventory_addition.get_gain_items():
		if item_grid.item_can_be_added(item):
			item_grid.add_item(item)
			inventory_addition.remove_item(item)
	var gain_food: int = inventory_addition.gain_food if _food + inventory_addition.gain_food <= max_food else max_food - _food
	inventory_addition.gain_food -= gain_food
	_food += gain_food
	emit_changed()

func can_add_addition(inventory_addition: InventoryAddition) -> bool:
	var item_grid_copy: ItemGrid = item_grid.duplicate()
	for item: ItemData in inventory_addition.get_gain_items():
		if item_grid_copy.item_can_be_added(item):
			item_grid_copy.add_item(item)
		else:
			return false
	return true

##Returns the amount of food in the inventory
func get_food() -> int:
	return _food

##Changes the amount of food in the inventory. Will not set food above [member Inventory.max_food] or below 0
func change_food(change: int) -> void:
	set_food(_food + change)

##Sets the amount of food in the inventory.  Will not set food above [member Inventory.max_food] or below 0
func set_food(new_food: int) -> void:
	_food = new_food
	_food = min(_food, max_food)
	_food = max(0, _food)
	emit_changed()

##Returns true if this inventory can spend [param inventory_requirement].
func meets_requirements(inventory_requirement: InventoryRequirement) -> bool:
	var indexes_used: Array[int] = []
	var items: Array[ItemData] = get_items()
	
	if batteries < inventory_requirement.batteries_cost or steel < inventory_requirement.steel_cost:
		return false
	
	#this iterates through each item in inventory_requirement.costs_items and ensures the item exists in items and hasn't been used yet.
	for item: ItemData in inventory_requirement.costs_items:
		var found_inventory_item := false
		for i: int in range(items.size()):
			if item == items[i] and not indexes_used.has(i):
				indexes_used.append(i)
				found_inventory_item = true
				break
		if !found_inventory_item:
			return false
	
	return true

##Attemps to spend the requirement. Returns true if successful, and false if not. The exchange might not be successful if the inventory does not meet the requirements.
func spend_requirement(inventory_requirement: InventoryRequirement) -> bool:
	if meets_requirements(inventory_requirement):
		batteries -= inventory_requirement.batteries_cost
		steel -= inventory_requirement.steel_cost
		for item: ItemData in inventory_requirement.costs_items:
			remove_item(item)
		return true
	else:
		return false
