@tool
extends Control

@onready var crafting_rows_container = $CraftingRowsContainer

@export var crafting_recipes: Array[CraftingRecipe]:
	set(new_value):
		crafting_recipes = new_value
		if is_node_ready():
			update_nodes()
@export var inventory: Inventory
@export var crafting_row_packed_scene: PackedScene

var crafting_rows: Array[CraftingRow]:
	get:
		var crafting_rows: Array[Node] = crafting_rows_container.get_children()
		var crafting_rows_typed: Array[CraftingRow]
		crafting_rows_typed.assign(crafting_rows)
		return crafting_rows_typed

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
	crafting_row.disabled = not inventory.meets_requirements(crafting_recipe.requirement)
	crafting_row.craft_pressed.connect(_on_crafting_row_craft_pressed)
	crafting_rows_container.add_child(crafting_row)

func _on_crafting_row_craft_pressed(crafting_recipe: CraftingRecipe):
	if inventory.spend_requirement(crafting_recipe.requirement):
		inventory.add_item(crafting_recipe.crafting_item)
	update_nodes()
