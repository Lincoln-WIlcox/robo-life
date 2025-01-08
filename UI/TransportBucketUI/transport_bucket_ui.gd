class_name TransportBucketUI
extends Control

@onready var power_pole_selection_map: PowerPoleSelectionMap = $PowerPoleSelectionMap
@onready var transport_bucket_inventory_ui: Control = $TransportBucketInventory
@onready var two_inventory_interface: TwoInventoryUI = $TransportBucketInventory/ContentContainer/TwoInventoryInterfaces
@onready var food_transfer_handler = $FoodTransferHandler
@onready var steel_transfer_handler = $SteelTransferHandler

var player_inventory: Inventory
var transport_bucket_inventory: Inventory
var _in_inventory := true

signal closed

func setup(map_data: MapData) -> void:
	if not is_node_ready():
		await ready
	
	two_inventory_interface.item_grid_one = transport_bucket_inventory.item_grid
	two_inventory_interface.item_grid_two = player_inventory.item_grid
	
	power_pole_selection_map.display_map_data(map_data)
	
	player_inventory.changed.connect(_on_player_inventory_changed)
	transport_bucket_inventory.changed.connect(_on_transport_bucket_inventory_changed)
	
	food_transfer_handler.get_player_counter_value = func() -> int: return player_inventory.get_food()
	food_transfer_handler.set_player_counter_value = func(new_value) -> void: player_inventory.set_food(new_value)
	food_transfer_handler.get_transport_bucket_counter_value = func() -> int: return transport_bucket_inventory.get_food()
	food_transfer_handler.set_transport_bucket_counter_value = func(new_value) -> void: transport_bucket_inventory.set_food(new_value)
	food_transfer_handler.can_transfer_to_player = func() -> bool: return player_inventory.get_food() < player_inventory.max_food
	food_transfer_handler.can_transfer_to_transport_bucket = func() -> bool: return transport_bucket_inventory.get_food() < transport_bucket_inventory.max_food
	
	steel_transfer_handler.get_player_counter_value = func() -> int: return player_inventory.steel
	steel_transfer_handler.set_player_counter_value = func(new_value) -> void: player_inventory.steel = new_value
	steel_transfer_handler.get_transport_bucket_counter_value = func() -> int: return transport_bucket_inventory.steel
	steel_transfer_handler.set_transport_bucket_counter_value = func(new_value) -> void: transport_bucket_inventory.steel = new_value

func _on_player_inventory_changed() -> void:
	food_transfer_handler.on_player_inventory_changed()
	steel_transfer_handler.on_player_inventory_changed()

func _on_transport_bucket_inventory_changed() -> void:
	food_transfer_handler.on_transport_bucket_inventory_changed()
	steel_transfer_handler.on_transport_bucket_inventory_changed()

func close() -> void:
	_go_to_inventory()
	power_pole_selection_map.reset_selected_power_pole()
	closed.emit()

func _go_to_inventory() -> void:
	transport_bucket_inventory_ui.show()
	power_pole_selection_map.hide()
	_in_inventory = true

func _go_to_power_pole_selection_map() -> void:
	transport_bucket_inventory_ui.hide()
	power_pole_selection_map.show()
	_in_inventory = false

func _on_power_pole_selection_map_cancelled():
	_go_to_inventory()

func _on_choose_destination_button_pressed():
	_go_to_power_pole_selection_map()

func _on_close_button_pressed():
	close()

func _on_power_pole_selection_map_power_pole_selected(_selected_power_pole):
	close()
