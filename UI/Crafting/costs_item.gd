@tool
class_name CraftingRowItem
extends MarginContainer

const AMOUNT_LABEL_TEXT = "Amount: "

@onready var item_texture = %ItemTexture
@onready var item_name_label = %ItemNameLabel
@onready var amount_label = %AmountLabel
@onready var amount_margin = %AmountMargin

@export var item_data: ItemData:
	set(new_value):
		item_data = new_value
		if is_node_ready():
			update_nodes()
@export var amount := 1:
	set(new_value):
		amount = new_value
		assert(amount > 0, "amount must be greater than 0")
		if is_node_ready():
			update_nodes()

func _ready():
	update_nodes()

func update_nodes() -> void:
	if item_data:
		item_texture.texture = item_data.texture
		item_name_label.text = item_data.name
	else:
		item_texture.texture = Texture.new()
		item_name_label.text = ""
	amount_label.text = AMOUNT_LABEL_TEXT + str(amount)
	
	amount_margin.visible = true if amount > 1 else false
