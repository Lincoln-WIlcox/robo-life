class_name DamagedUnit
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

@export var repaired_texture: Texture

var _is_repaired: bool = false
var _unrepaired_texture: Texture = sprite.texture

signal repaired
signal unrepaired

func get_repaired() -> bool:
	return _is_repaired

func repair() -> void:
	_is_repaired = true
	sprite.texture = repaired_texture
	repaired.emit()

func unrepair() -> void:
	_is_repaired = false
	sprite.texture = _unrepaired_texture
	unrepaired.emit()

func _on_mouse_interaction_area_interacted_with():
	repair()
