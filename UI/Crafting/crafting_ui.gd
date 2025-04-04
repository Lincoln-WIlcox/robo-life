@tool
extends Control

@onready var crafting_rows_container = %CraftingRowsContainer

@export var crafting_recipes: Array[CraftingRecipe]:
	set(new_value):
		crafting_recipes = new_value
		if is_node_ready():
			update_nodes()
@export var player_inventory: Inventory
@export var shelter_inventory: Inventory
@export var crafting_row_packed_scene: PackedScene

var crafting_rows: Array[CraftingRow]:
	get:
		var return_crafting_rows: Array[CraftingRow]
		var return_crafting_rows_assigner: Array[Node] = crafting_rows_container.get_children()
		return_crafting_rows.assign(return_crafting_rows_assigner)
		return return_crafting_rows

signal return_pressed

func _ready():
	update_nodes()

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
	return (not player_inventory.meets_requirements(crafting_recipe.requirement)) or (not player_inventory.can_add_addition(crafting_recipe.inventory_addition) and not shelter_inventory.can_add_addition(crafting_recipe.inventory_addition))

func _on_crafting_row_craft_pressed(crafting_recipe: CraftingRecipe):
	if player_inventory.meets_requirements(crafting_recipe.requirement):
		if player_inventory.can_add_addition(crafting_recipe.inventory_addition):
			player_inventory.spend_requirement(crafting_recipe.requirement.duplicate())
			player_inventory.add_addition(crafting_recipe.inventory_addition.duplicate())
		elif shelter_inventory.can_add_addition(crafting_recipe.inventory_addition):
			player_inventory.spend_requirement(crafting_recipe.requirement.duplicate())
			shelter_inventory.add_addition(crafting_recipe.inventory_addition.duplicate())
	update_nodes()

func _on_return_button_pressed():
	return_pressed.emit()
