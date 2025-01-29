@tool
class_name CraftingRow
extends Control

const STEEL_TEXT = "steel: "

@onready var craft_button = %CraftButton
@onready var crafting_items_hbox = %CraftingItemsHbox
@onready var costs_items_hbox = %CostItemsHbox
@onready var costs_steel_label = %CostsSteelLabel
@onready var costs_batteries_label = %CostsBatteriesLabel
@onready var costs_steel_margin = %CostsSteelMargin
@onready var costs_batteries_margin = %CostsBatteriesMargin

var _handling_crafting_row_items: Array[CraftingRowItem]

@export var crafting_recipe: CraftingRecipe:
	set(new_value):
		crafting_recipe = new_value
		if is_node_ready():
			print("changing!")
			update_nodes()
@export var crafting_row_item_packed_scene: PackedScene
@export var disabled := false:
	set(new_value):
		disabled = new_value
		if is_node_ready():
			update_nodes()

signal craft_pressed(crafting_recipe: CraftingRecipe)

func _ready():
	update_nodes()

func update_nodes() -> void:
	craft_button.disabled = disabled
	
	for crafting_row_item: CraftingRowItem in _handling_crafting_row_items:
		print("deleting crafting row item ", crafting_row_item.item_data.name)
		crafting_row_item.queue_free()
	
	_handling_crafting_row_items = []
	
	if crafting_recipe:
		
		var getting_items: Array[ItemData]
		
		if Engine.is_editor_hint():
			getting_items = crafting_recipe.inventory_addition.initial_gain_items
		else:
			getting_items = crafting_recipe.inventory_addition.get_gain_items()
			
		display_items(getting_items, crafting_items_hbox)
		
		costs_steel_label.text = str(crafting_recipe.requirement.steel_cost)
		costs_batteries_label.text = str(crafting_recipe.requirement.batteries_cost)
		costs_steel_margin.visible = crafting_recipe.requirement.steel_cost > 0
		costs_batteries_margin.visible = crafting_recipe.requirement.batteries_cost > 0
		
		costs_items_hbox.visible = crafting_recipe.requirement.costs_items.size() > 0
		display_items(crafting_recipe.requirement.costs_items, costs_items_hbox)
	else:
		costs_steel_margin.visible = false
		costs_batteries_margin.visible = false

func display_items(items: Array[ItemData], in_node: Node) -> void:
	var costs_items_duplicate = items.duplicate()
	
	#gets the amount of an item in costs_items_duplicate, removes all of the instances of that item, then calls create-costs_item_row passing the item and amount of it.
	for i: int in range(costs_items_duplicate.size() - 1, -1, -1):
		if i > costs_items_duplicate.size() - 1:
			continue
		var item: ItemData = costs_items_duplicate[i]
		var amount := 0
		for x: int in range(costs_items_duplicate.size() - 1, -1, -1):
			if item.name == costs_items_duplicate[x].name:
				amount += 1
				costs_items_duplicate.remove_at(x)
		var display_item: CraftingRowItem = create_crafting_row_item(item, amount)
		in_node.add_child(display_item)
		_handling_crafting_row_items.append(display_item)

func create_crafting_row_item(item: ItemData, amount: int) -> CraftingRowItem:
	var costs_item_scene: CraftingRowItem = crafting_row_item_packed_scene.instantiate()
	costs_item_scene.item_data = item
	costs_item_scene.amount = amount
	return costs_item_scene

func _on_craft_button_pressed():
	craft_pressed.emit(crafting_recipe)
