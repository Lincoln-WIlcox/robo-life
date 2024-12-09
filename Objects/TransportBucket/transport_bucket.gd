class_name TransportBucket
extends Node2D

@onready var mouse_pickup_area = $MousePickupArea

@export var initial_inventory: Inventory
@export var transport_bucket_item: ItemData

var _inventory: Inventory = Inventory.new()

func _ready():
	if initial_inventory:
		_inventory = initial_inventory
	update_inventory_addition()
	_inventory.changed.connect(update_inventory_addition)

func update_inventory_addition() -> void:
	var inventory_addition: InventoryAddition = InventoryAddition.new()
	if _inventory:
		inventory_addition = _inventory.to_inventory_addition()
	inventory_addition.add_item(transport_bucket_item)
	mouse_pickup_area.inventory_addition = inventory_addition
