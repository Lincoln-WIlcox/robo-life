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
	crafting_row.disabled = not player_inventory.meets_requirements(crafting_recipe.requirement) and (player_inventory.item_grid.item_can_be_added(crafting_recipe.crafting_item) or shelter_inventory.item_grid.item_can_be_added(crafting_recipe.crafting_item))
	crafting_row.craft_pressed.connect(_on_crafting_row_craft_pressed)
	crafting_rows_container.add_child(crafting_row)

func _on_crafting_row_craft_pressed(crafting_recipe: CraftingRecipe):
	if player_inventory.meets_requirements(crafting_recipe.requirement):
		if player_inventory.item_grid.item_can_be_added(crafting_recipe.crafting_item):
			player_inventory.spend_requirement(crafting_recipe.requirement)
			player_inventory.add_item(crafting_recipe.crafting_item)
		elif shelter_inventory.item_grid.item_can_be_added(crafting_recipe.crafting_item):
			player_inventory.spend_requirement(crafting_recipe.requirement)
			shelter_inventory.add_item(crafting_recipe.crafting_item)
	update_nodes()

func _on_return_button_pressed():
	return_pressed.emit()
