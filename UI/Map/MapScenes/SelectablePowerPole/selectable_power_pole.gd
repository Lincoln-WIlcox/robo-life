class_name SelectablePowerPole
extends Node2D

const SELECTED_MODULATE = Color(1.3,1.3,1.3,1)
const DESELECTED_MODULATE = Color(.8,.8,.8,.5)

@onready var sprite = $Sprite2D

signal pressed

func _on_button_pressed():
	pressed.emit()

func select() -> void:
	sprite.modulate = SELECTED_MODULATE

func deselect() -> void:
	sprite.modulate = DESELECTED_MODULATE
