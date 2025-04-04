@tool
class_name CounterTransferUI
extends Control

const INVALID_COUNTER_TEXT = "?"

@export var counter_1: Counter:
	set(new_value):
		counter_1 = new_value
		_handle_new_counter(counter_1)
@export var counter_2: Counter:
	set(new_value):
		counter_2 = new_value
		_handle_new_counter(counter_2)
@export var texture: Texture:
	set(new_value):
		texture = new_value
		
		if is_node_ready():
			update_texture_rect()
		
		if Engine.is_editor_hint():
			$HBoxContainer/TextureRect.texture = texture

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label_1: Label = $HBoxContainer/Counter1Label
@onready var label_2: Label = $HBoxContainer/Counter2Label
@onready var transfer_to_1: Button = $HBoxContainer/TransferButtonsMargin/TransferButtonsContainer/TransferTo1
@onready var transfer_to_2: Button = $HBoxContainer/TransferButtonsMargin/TransferButtonsContainer/TransferTo2

func _ready():
	if texture:
		update_texture_rect()
	update_counters_ui()

func _handle_new_counter(counter: Counter) -> void:
	counter.changed.connect(update_counters_ui)
	update_counters_ui()

func update_texture_rect() -> void:
	texture_rect.texture = texture

func update_counters_ui() -> void:
	if counter_1 and counter_2:
		label_1.text = counter_1.value_as_string()
		label_2.text = counter_2.value_as_string()
		transfer_to_1.disabled = transfer_to_1_disabled()
		transfer_to_2.disabled = transfer_to_2_disabled()
	else:
		label_1.text = INVALID_COUNTER_TEXT
		label_2.text = INVALID_COUNTER_TEXT

func transfer_to_1_disabled() -> bool:
	return counter_2.value_is_min() or counter_1.value_is_max()

func transfer_to_2_disabled() -> bool:
	return counter_1.value_is_min() or counter_2.value_is_max()

func _on_transfer_to_1_pressed():
	counter_1.add_value(1)
	counter_2.subtract_value(1)
	update_counters_ui()

func _on_transfer_to_2_pressed():
	counter_2.add_value(1)
	counter_1.subtract_value(1)
	update_counters_ui()
