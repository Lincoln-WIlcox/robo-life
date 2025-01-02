extends Node

@export var transport_bucket_food_label: Label
@export var player_food_label: Label

@export var transfer_to_transport_bucket_button: Button
@export var transfer_to_player_button: Button

var player_inventory: Inventory:
	set(new_value):
		if player_inventory:
			player_inventory.changed.disconnect(_on_player_inventory_changed)
		
		player_inventory = new_value
		player_inventory.changed.connect(_on_player_inventory_changed)
		
		_update_player_food_label()
var transport_bucket_inventory: Inventory:
	set(new_value):
		if transport_bucket_inventory:
			transport_bucket_inventory.changed.disconnect(_on_transport_bucket_inventory_changed)
		
		transport_bucket_inventory = new_value
		transport_bucket_inventory.changed.connect(_on_transport_bucket_inventory_changed)
		
		_update_transport_bucket_food_label()

func _transfer_to_transport_bucket() -> void:
	transport_bucket_inventory.add_food()
	player_inventory.remove_food()

func _transfer_to_player() -> void:
	player_inventory.add_food()
	transport_bucket_inventory.remove_food()

func _update_buttons_disabled() -> void:
	transfer_to_player_button.disabled = not transport_bucket_inventory.has_food()
	transfer_to_transport_bucket_button.disabled = not player_inventory.has_food()

func _update_player_food_label() -> void:
	player_food_label.text = str(player_inventory.get_food())

func _update_transport_bucket_food_label() -> void:
	transport_bucket_food_label.text = str(transport_bucket_inventory.get_food())

func _on_transfer_to_bucket_pressed():
	if player_inventory.has_food():
		_transfer_to_transport_bucket()
	_update_buttons_disabled()

func _on_transfer_to_player_pressed():
	if transport_bucket_inventory.has_food():
		_transfer_to_player()
	_update_buttons_disabled()

func _on_player_inventory_changed() -> void:
	_update_player_food_label()

func _on_transport_bucket_inventory_changed() -> void:
	_update_transport_bucket_food_label()
