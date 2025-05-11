@tool
extends Control

@onready var crafting_rows_container = %CraftingRowsContainer

@export var crafting_recipes: Array[CraftingRecipe]:
	set(new_value):
		crafting_recipes = new_value
		if is_node_ready():
			update_nodes()
@export var player_inventory: Inventory:
	set(new_value):
		player_inventory = new_value
		_update_composite_inventory()
@export var shelter_inventory: Inventory:
	set(new_value):
		shelter_inventory = new_value
		_update_composite_inventory()
@export var crafting_row_packed_scene: PackedScene

var crafting_rows: Array[CraftingRow]:
	get:
		var return_crafting_rows: Array[CraftingRow]
		var return_crafting_rows_assigner: Array[Node] = crafting_rows_container.get_children()
		return_crafting_rows.assign(return_crafting_rows_assigner)
		return return_crafting_rows
var _composite_inventory: CompositeInventory

signal return_pressed

func _ready():
	update_nodes()
	_update_composite_inventory()

func update_nodes() -> void:
	for child: Node in crafting_rows:
		child.queue_free()
	
	for crafting_recipe: CraftingRecipe in crafting_recipes:
		creating_crafting_row(crafting_recipe)

func creating_crafting_row(crafting_recipe: CraftingRecipe) -> void:
	var crafting_row: CraftingRow = crafting_row_packed_scene.instantiate()
	crafting_row.crafting_recipe = crafting_recipe
	crafting_row.disabled = crafting_row_disabled(crafting_recipe)
	crafting_row.craft_pressed.connect(_on_crafting_row_craft_pressed)
	crafting_rows_container.add_child(crafting_row)

func crafting_row_disabled(crafting_recipe: CraftingRecipe) -> bool:
	return not(_composite_inventory.meets_requirement(crafting_recipe.requirement) and _composite_inventory.can_add_addition(crafting_recipe.inventory_addition))

func _update_composite_inventory() -> void:
	var inventories: Array[Inventory] = []
	if player_inventory:
		inventories.append(player_inventory)
	if shelter_inventory:
		inventories.append(shelter_inventory)
	_composite_inventory = CompositeInventory.make_from_inventories(inventories)

func _on_crafting_row_craft_pressed(crafting_recipe: CraftingRecipe):
	if _composite_inventory.meets_requirement(crafting_recipe.requirement) and _composite_inventory.can_add_addition(crafting_recipe.inventory_addition):
		_composite_inventory.spend_requirement(crafting_recipe.requirement.duplicate())
		_composite_inventory.add_addition(crafting_recipe.inventory_addition.duplicate())
	update_nodes()

func _on_return_button_pressed():
	return_pressed.emit()
