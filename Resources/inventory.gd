class_name Inventory
extends Resource

##Used to represent the batteries, steel, food and items a character or object holds

@export var batteries: Counter = Counter.new():
	set(new_value):
		batteries = new_value
		batteries.changed.connect(emit_changed)
@export var steel: Counter = Counter.new():
	set(new_value):
		steel = new_value
		steel.changed.connect(emit_changed)
@export var food: Counter = Counter.new():
	set(new_value):
		food = new_value
		food.changed.connect(emit_changed)
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
	inventory_addition.gain_batteries = batteries.add_value(inventory_addition.gain_batteries)
	inventory_addition.gain_steel = steel.add_value(inventory_addition.gain_steel)
	inventory_addition.gain_food = food.add_value(inventory_addition.gain_food)
	var gaining_items: Array[ItemData]
	for item: ItemData in inventory_addition.get_gain_items():
		if item_grid.item_can_be_added(item):
			gaining_items.append(item)
	for item: ItemData in gaining_items:
		var item_added: bool = item_grid.add_item(item)
		if item_added:
			inventory_addition.remove_item(item)
	emit_changed()

func can_add_addition(inventory_addition: InventoryAddition) -> bool:
	if not batteries.can_add_value(inventory_addition.gain_batteries) or not steel.can_add_value(inventory_addition.gain_steel) or not food.can_add_value(inventory_addition.gain_food):
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
	var inventory_addition: InventoryAddition = InventoryAddition.new(batteries.value, steel.value, food.value, items)
	return inventory_addition

##Returns true if this inventory can spend [param inventory_requirement].
func meets_requirements(inventory_requirement: InventoryRequirement) -> bool:
	var indexes_used: Array[int] = []
	var items: Array[ItemData] = get_items()
	if not batteries.can_subtract_value(inventory_requirement.batteries_cost) or not steel.can_subtract_value(inventory_requirement.steel_cost):
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
		batteries.subtract_value(inventory_requirement.batteries_cost)
		steel.subtract_value(inventory_requirement.steel_cost)
		for item: ItemData in inventory_requirement.costs_items:
			remove_item(item)
		return true
	else:
		return false

##Overwrites the inventory contents to use the new data in [param new_inventory].
func use_data(new_inventory: Inventory) -> void:
	batteries = new_inventory.batteries.duplicate()
	steel = new_inventory.steel.duplicate()
	food = new_inventory.food.duplicate()
	item_grid.remove_all()
	item_grid.size = new_inventory.item_grid.size
	for item: ItemGridItem in new_inventory.item_grid.get_grid_items():
		item_grid.add_grid_item(item)
