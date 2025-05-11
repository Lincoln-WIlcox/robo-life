class_name CompositeInventory
extends RefCounted

##Allows you to take and add to and from multiple inventories.

var _inventories: Array[Inventory]


##Returns a CompositeInventory using the given inventories. Inventories earlier in the array will have higher priority.
static func make_from_inventories(inventories: Array[Inventory]) -> CompositeInventory:
	var new_composite_inventory: CompositeInventory = CompositeInventory.new()
	new_composite_inventory.add_inventories(inventories)
	return new_composite_inventory


# funcs for managing inventories #

##Returns the inventories in the composite.
func get_inventories() -> Array[Inventory]:
	return _inventories.duplicate()

##Returns amount of inventories.
func get_inventories_count() -> int:
	return _inventories.size()

##Adds an inventory. Will have lowest priority in the list.
func add_least_priority_inventory(new_inventory: Inventory) -> void:
	_inventories.append(new_inventory)

##Adds each inventory in new_inventories. The passed inventories will have the least priorities, and inventories earlier in the array will have higher relative priority within the array.
func add_inventories(new_inventories: Array[Inventory]) -> void:
	_inventories.append_array(new_inventories)

##Adds an inventory. Will have highest priority in the list.
func add_most_priority_inventory(new_inventory: Inventory) -> void:
	_inventories.insert(0, new_inventory)

##Inserts an inventory at given index, which correlates with its priority.
func insert_inventory_at_index(index: int, new_inventory: Inventory) -> void:
	_inventories.insert(index, new_inventory)

##Erases [param removing_inventory] from the composite. If [removing_inventory[ is not in the composite, nothing happens.
func erase_inventory(removing_inventory: Inventory) -> void:
	_inventories.erase(removing_inventory)

##Removes inventory at given index.
func remove_at(index: int) -> void:
	_inventories.remove_at(index)


# funcs for managing inventory contents #

##Adds batteries to the composite. Returns the leftover amount if not all batteries could be added.
func add_batteries(amount: int) -> int:
	var battery_counters: Array[Counter] = _get_battery_counters()
	var leftover_amount: int = _add_value_to_counters(battery_counters, amount)
	return leftover_amount

##Removes batteries from the composite. Returns the leftover amount if not all batteries could be removed.
func remove_batteries(amount: int) -> int:
	var battery_counters: Array[Counter] = _get_battery_counters()
	var leftover_amount: int = _remove_value_from_counters(battery_counters, amount)
	return leftover_amount

##Returns true if inventories can accept the given amount of batteries. Otherwise return false.
func can_add_batteries(amount: int) -> bool:
	var battery_counters: Array[Counter] = _get_battery_counters()
	return _can_add_to_counters(battery_counters, amount)

##Returns true if inventories can remove the given amount of batteries. Otherwise return false.
func can_remove_batteries(amount: int) -> bool:
	var battery_counters: Array[Counter] = _get_battery_counters()
	return _can_remove_from_counters(battery_counters, amount)

##Adds steel to the composite. Returns the leftover amount if not all steel could be added.
func add_steel(amount: int) -> int:
	var steel_counters: Array[Counter] = _get_steel_counters()
	var leftover_amount: int = _add_value_to_counters(steel_counters, amount)
	return leftover_amount

##Removes steel from the composite. Returns the leftover amount if not all steel could be removed.
func remove_steel(amount: int) -> int:
	var steel_counters: Array[Counter] = _get_steel_counters()
	var leftover_amount: int = _remove_value_from_counters(steel_counters, amount)
	return leftover_amount

##Returns true if inventories can accept the given amount of steel. Otherwise return false.
func can_add_steel(amount: int) -> bool:
	var steel_counters: Array[Counter] = _get_steel_counters()
	return _can_add_to_counters(steel_counters, amount)

##Returns true if inventories can remove the given amount of steel. Otherwise return false.
func can_remove_steel(amount: int) -> bool:
	var steel_counters: Array[Counter] = _get_steel_counters()
	return _can_remove_from_counters(steel_counters, amount)

##Adds food to the composite. Returns the leftover amount if not all food could be added.
func add_food(amount: int) -> int:
	var food_counters: Array[Counter] = _get_food_counters()
	var leftover_amount: int = _remove_value_from_counters(food_counters, amount)
	return leftover_amount

##Removes food from the composite. Returns the leftover amount if not all food could be removed.
func remove_food(amount: int) -> int:
	var food_counters: Array[Counter] = _get_food_counters()
	var leftover_amount: int = _remove_value_from_counters(food_counters, amount)
	return leftover_amount

##Returns true if inventories can accept the given amount of food. Otherwise return false.
func can_add_food(amount: int) -> bool:
	var food_counters: Array[Counter] = _get_food_counters()
	return _can_add_to_counters(food_counters, amount)

##Returns true if inventories can remove the given amount of food. Otherwise return false.
func can_remove_food(amount: int) -> bool:
	var food_counters: Array[Counter] = _get_food_counters()
	return _can_remove_from_counters(food_counters, amount)

##Adds an item to the first inventory that has space for it. Returns true if the item was added.
func add_item(item: ItemData) -> bool:
	for inventory: Inventory in _inventories:
		var success: bool = inventory.add_item(item)
		
		if success:
			return true
	return false

##Removes an item to the first inventory that has it.
func remove_item(item: ItemData) -> void:
	for inventory: Inventory in _inventories:
		if inventory.has_item(item):
			inventory.remove_item(item)
			return

##Returns true if any inventory has [param item].
func has_item(item: ItemData) -> bool:
	for inventory: Inventory in _inventories:
		if inventory.has_item(item):
			return true
	return false

##Adds an addition to the composite. Anything left over after adding the addition to the highest priority inventory is given to the next inventory.
func add_addition(inventory_addition: InventoryAddition) -> void:
	for inventory: Inventory in _inventories:
		inventory.add_addition(inventory_addition)
		
		if inventory_addition.is_empty():
			return

##Returns true if the composite can accept the inventory addition.
func can_add_addition(inventory_addition: InventoryAddition) -> bool:
	var duplicate_inventories_assigner: Array = _inventories.map(func(i: Inventory) -> Inventory: return i.duplicate(true))
	var duplicate_inventories: Array[Inventory]
	duplicate_inventories.assign(duplicate_inventories_assigner)
	
	var duplicate_inventory_addition: InventoryAddition = inventory_addition.duplicate()
	
	for inventory: Inventory in duplicate_inventories:
		if inventory.can_add_addition(duplicate_inventory_addition):
			return true
		
		inventory.add_addition(duplicate_inventory_addition)
	return false

##Spends the requirement using the composite.
func spend_requirement(inventory_requirement: InventoryRequirement) -> bool:
	if not meets_requirement(inventory_requirement):
		return false
	
	for inventory: Inventory in _inventories:
		if inventory_requirement.is_empty():
			return true
		
		inventory.spend_and_update_requirement(inventory_requirement, true)
	return inventory_requirement.is_empty()

##Returns true if the composite meets the requirement.
func meets_requirement(inventory_requirement: InventoryRequirement) -> bool:
	var duplicate_inventories_assigner: Array = _inventories.map(func(i: Inventory) -> Inventory: return i.duplicate(true))
	var duplicate_inventories: Array[Inventory]
	duplicate_inventories.assign(duplicate_inventories_assigner)
	
	var duplicate_inventory_requirement: InventoryRequirement = inventory_requirement.duplicate()
	
	for inventory: Inventory in duplicate_inventories:
		if duplicate_inventory_requirement.is_empty():
			return true
		
		inventory.spend_and_update_requirement(duplicate_inventory_requirement)
	
	return duplicate_inventory_requirement.is_empty()


# private funcs #

func _get_battery_counters() -> Array[Counter]:
	return _inventories.map(func(i: Inventory) -> Counter: return i.batteries)

func _get_steel_counters() -> Array[Counter]:
	return _inventories.map(func(i: Inventory) -> Counter: return i.steel)

func _get_food_counters() -> Array[Counter]:
	return _inventories.map(func(i: Inventory) -> Counter: return i.food)

func _add_value_to_counters(counters: Array[Counter], amount: int) -> int:
	for counter: Counter in counters:
		amount = counter.add_value(amount)
		
		if amount == 0:
			break
	return amount

func _remove_value_from_counters(counters: Array[Counter], amount: int) -> int:
	for counter: Counter in counters:
		amount = counter.remove_value(amount)
		
		if amount == 0:
			break
	return amount

func _can_add_to_counters(counters: Array[Counter], amount: int) -> bool:
	var duplicate_counters: Array[Counter] = counters.map(func(c: Counter) -> Counter: return c.duplicate())
	
	for counter: Counter in duplicate_counters:
		if counter.can_add_value(amount):
			return true
		
		amount = counter.add_value(amount)
	return false

func _can_remove_from_counters(counters: Array[Counter], amount: int) -> bool:
	var duplicate_counters: Array[Counter] = counters.map(func(c: Counter) -> Counter: return c.duplicate())
	
	for counter: Counter in duplicate_counters:
		if counter.can_subtract_value(amount):
			return true
		
		amount = counter.subtract_value(amount)
	return false
