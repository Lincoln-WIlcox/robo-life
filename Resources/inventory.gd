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
##The amount of food
@export var food := 0:
	set(new_value):
		food = new_value
		emit_changed()
##The maximum amount of food this inventory can hold. Using [method change_food] will not allow food to go above this value
@export var max_food := 50:
	set(new_value):
		max_food = new_value
		emit_changed()
##The initial value for the item grid. The item grid itself is private. To interact with it, use the functions provided
@export var item_grid: ItemGrid:
	set(new_value):
		item_grid = new_value
		if item_grid != null:
			item_grid.changed.connect(func(): emit_changed())
		emit_changed()

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
	return item_grid.get_items() if item_grid else []

##Returns true if the item grid contains the given item
func has_item(item: ItemData) -> bool:
	return item_grid.has_item(item)

##Adds an [InventoryAddition] to the inventory. Anything the inventory takes is subtracted from [param inventory_addition]. If the inventory can't take something in an addition, it will only subtract what it can take from the inventory addition.
func add_addition(inventory_addition: InventoryAddition) -> void:
	batteries += inventory_addition.gain_batteries
	inventory_addition.gain_batteries = 0
	steel += inventory_addition.gain_steel
	inventory_addition.gain_steel = 0
	var gaining_items: Array[ItemData]
	for item: ItemData in inventory_addition.get_gain_items():
		if item_grid.item_can_be_added(item):
			gaining_items.append(item)
	for item: ItemData in gaining_items:
		item_grid.add_item(item)
		inventory_addition.remove_item(item)
	var gain_food: int = inventory_addition.gain_food if food + inventory_addition.gain_food <= max_food else max_food - food
	inventory_addition.gain_food -= gain_food
	food += gain_food
	emit_changed()

func can_add_addition(inventory_addition: InventoryAddition) -> bool:
	if inventory_addition.gain_food + food > max_food:
		return false
	
	var item_grid_copy: ItemGrid = item_grid.duplicate()
	for item: ItemData in inventory_addition.get_gain_items():
		if item_grid_copy.item_can_be_added(item):
			item_grid_copy.add_item(item)
		else:
			return false
	return true

func to_inventory_addition() -> InventoryAddition:
	var items: Array[ItemData]
	var items_assigner: Array = get_items()
	items.assign(items_assigner)
	var inventory_addition: InventoryAddition = InventoryAddition.new(batteries,steel,food,items)
	return inventory_addition

##Returns the amount of food in the inventory
func get_food() -> int:
	return food

##Returns true if inventory has food.
func has_food() -> bool:
	return food > 0

##Changes the amount of food in the inventory. Will not set food above [member Inventory.max_food] or below 0
func change_food(change: int) -> void:
	set_food(food + change)

##Adds food. See [method Inventory.set_food]
func add_food(amount: int = 1) -> void:
	set_food(food + amount)

##Removes food. See [method Inventory.set_food]
func remove_food(amount: int = 1) -> void:
	set_food(food - amount)

##Sets the amount of food in the inventory.  Will not set food above [member Inventory.max_food] or below 0
func set_food(new_food: int) -> void:
	food = new_food
	food = min(food, max_food)
	food = max(0, food)
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
