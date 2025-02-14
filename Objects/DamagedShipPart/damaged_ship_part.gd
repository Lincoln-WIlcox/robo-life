class_name DamagedShipPart
extends Node2D

@export var repaired_texture: Texture
@export var map_texture: MapTexture

var _is_repaired: bool = false

@onready var sprite = $Sprite2D

signal repaired
signal unrepaired

func _ready():
	map_texture.get_position = func() -> Vector2: return global_position
	EventBus.emit_map_entity_added(map_texture)

func get_repaired() -> bool:
	return _is_repaired

func repair() -> void:
	_is_repaired = true
	repaired.emit()
	sprite.texture = repaired_texture
	map_texture.display_texture = repaired_texture
