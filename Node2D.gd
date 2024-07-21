extends Node2D

@export var inventory: Inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	print(inventory._item_grid.size)
