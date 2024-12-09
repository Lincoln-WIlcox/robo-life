class_name TransportBucket
extends Placeable

@onready var mouse_pickup_area = $MousePickupArea

@export var initial_inventory: Inventory
@export var transport_bucket_item: ItemData
@export var start_placed := false

var _inventory: Inventory = Inventory.new()

func _ready():
	super()
	
	if initial_inventory:
		_inventory = initial_inventory
	update_inventory_addition()
	_inventory.changed.connect(update_inventory_addition)
	
	if start_placed:
		#for some reason you have to wait two physics frams
		#await Engine.get_main_loop().physics_frame
		#await Engine.get_main_loop().physics_frame
		place()

func update_inventory_addition() -> void:
	var inventory_addition: InventoryAddition = InventoryAddition.new()
	if _inventory:
		inventory_addition = _inventory.to_inventory_addition()
	inventory_addition.add_item(transport_bucket_item)
	mouse_pickup_area.inventory_addition = inventory_addition
