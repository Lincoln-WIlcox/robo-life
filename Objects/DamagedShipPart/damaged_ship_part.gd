class_name DamagedShipPart
extends Node2D

@onready var sprite = $Sprite2D

@export var repaired_texture: Texture

var _is_repaired: bool = false

signal repaired
signal unrepaired

func get_repaired() -> bool:
	return _is_repaired

func repair() -> void:
	_is_repaired = true
	repaired.emit()
	sprite.texture = repaired_texture
