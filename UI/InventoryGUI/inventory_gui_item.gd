@tool
class_name InventoryGUIItem
extends Control

@onready var texture_rect = %TextureRect
@onready var drop_button = %DropButton
@onready var name_label = %Name

@export var item: ItemData:
	set(new_value):
		item = new_value
		
		if is_inside_tree():
			_update_nodes()

signal dropped

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_nodes()
	drop_button.pressed.connect(func(): dropped.emit())

func _update_nodes():
	texture_rect.texture = item.texture
	name_label.text = item.name
