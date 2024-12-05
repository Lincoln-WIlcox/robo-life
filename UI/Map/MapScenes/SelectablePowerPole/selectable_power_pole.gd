class_name SelectablePowerPole
extends Node2D

signal pressed

var _selected := false

func _on_button_pressed():
	pressed.emit()

func select() -> void:
	_selected = true;

func deselect() -> void:
	_selected = false;
