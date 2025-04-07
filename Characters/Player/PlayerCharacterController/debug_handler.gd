extends Node

@export var drill_item: ItemData
@export var transport_bucket_item: ItemData
@export var power_pole_item: ItemData

var player_inventory: Inventory

func _ready():
	Debug.give_battery_pressed.connect(_on_give_battery_pressed)
	Debug.give_steel_pressed.connect(_on_give_steel_pressed)
	Debug.give_food_pressed.connect(_on_give_food_pressed)
	Debug.give_drill_pressed.connect(_on_give_drill_pressed)
	Debug.give_transport_bucket_pressed.connect(_on_give_transport_bucket_pressed)
	Debug.give_power_pole_pressed.connect(_on_give_power_pole_pressed)

func _on_give_battery_pressed() -> void:
	player_inventory.batteries.add_value(1)

func _on_give_steel_pressed() -> void:
	player_inventory.steel.add_value(1)

func _on_give_food_pressed() -> void:
	player_inventory.food.add_value(1)

func _on_give_drill_pressed() -> void:
	player_inventory.add_item(drill_item)

func _on_give_transport_bucket_pressed() -> void:
	player_inventory.add_item(transport_bucket_item)

func _on_give_power_pole_pressed() -> void:
	player_inventory.add_item(power_pole_item)
