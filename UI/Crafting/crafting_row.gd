@tool
class_name CraftingRow
extends Control

const STEEL_TEXT = "steel: "

@onready var craft_item_texture = %CraftItemTexture
@onready var craft_item_label = %CraftItemLabel
@onready var costs_items_hbox = %CostItemsHbox
@onready var steel_label = %SteelLabel
@onready var craft_button = %CraftButton

var _costs_items: Array[CostsItem]:
	get:
		var costs_items: Array[Node] = costs_items_hbox.get_children().filter(func(c: Node): return c is CostsItem)
		var costs_items_typed: Array[CostsItem]
		costs_items_typed.assign(costs_items)
		return costs_items_typed

@export var crafting_recipe: CraftingRecipe:
	set(new_value):
		crafting_recipe = new_value
		if is_node_ready():
			update_nodes()
@export var costs_item_packed_scene: PackedScene
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
	
	for costs_item: CostsItem in _costs_items:
		costs_item.queue_free()
	
	if crafting_recipe:
		craft_item_texture.texture = crafting_recipe.crafting_item.texture
		craft_item_label.text = crafting_recipe.crafting_item.name
		steel_label.text = STEEL_TEXT + str(crafting_recipe.requirement.steel_cost)
		
		costs_items_hbox.visible = crafting_recipe.requirement.costs_items.size() > 0
		create_cost_items(crafting_recipe.requirement.costs_items)
	else:
		craft_item_texture.texture = Texture.new()
		craft_item_label.text = ""
		steel_label.text = STEEL_TEXT

func create_cost_items(cost_items: Array[ItemData]) -> void:
	var costs_items_duplicate = cost_items.duplicate()
	
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
		create_costs_item_row(item, amount)

func create_costs_item_row(item: ItemData, amount) -> void:
	var costs_item_scene: CostsItem = costs_item_packed_scene.instantiate()
	costs_item_scene.item_data = item
	costs_item_scene.amount = amount
	
	costs_items_hbox.add_child(costs_item_scene)

func _on_craft_button_pressed():
	craft_pressed.emit(crafting_recipe)
