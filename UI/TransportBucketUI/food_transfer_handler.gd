extends Node

@export var transport_bucket_label: Label
@export var player_label: Label

@export var transfer_to_transport_bucket_button: Button
@export var transfer_to_player_button: Button

var get_player_counter_value: Callable:
	set(new_value):
		get_player_counter_value = new_value
		_update_player_label()
		_update_buttons_disabled()
var set_player_counter_value: Callable
var get_transport_bucket_counter_value: Callable:
	set(new_value):
		get_transport_bucket_counter_value = new_value
		_update_transport_bucket_label()
		_update_buttons_disabled()
var set_transport_bucket_counter_value: Callable

var player_counter:
	set(new_value):
		set_player_counter_value.call(new_value)
	get:
		return get_player_counter_value.call()
var transport_bucket_counter:
	set(new_value):
		set_transport_bucket_counter_value.call(new_value)
	get:
		return get_transport_bucket_counter_value.call()

func on_player_inventory_changed() -> void:
	_update_player_label()
	_update_buttons_disabled()

func on_transport_bucket_inventory_changed() -> void:
	_update_transport_bucket_label()
	_update_buttons_disabled()

func _update_player_label() -> void:
	player_label.text = str(player_counter)

func _update_transport_bucket_label() -> void:
	transport_bucket_label.text = str(transport_bucket_counter)

func _transfer_to_transport_bucket() -> void:
	transport_bucket_counter += 1
	player_counter -= 1

func _transfer_to_player() -> void:
	player_counter += 1
	transport_bucket_counter -= 1

func _update_buttons_disabled() -> void:
	if get_transport_bucket_counter_value:
		transfer_to_player_button.disabled = not transport_bucket_counter > 0
	if get_player_counter_value:
		transfer_to_transport_bucket_button.disabled = not player_counter > 0

func _on_transfer_to_bucket_pressed():
	if player_counter > 0:
		_transfer_to_transport_bucket()
	_update_buttons_disabled()

func _on_transfer_to_player_pressed():
	if transport_bucket_counter > 0:
		_transfer_to_player()
	_update_buttons_disabled()
