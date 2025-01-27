class_name SelectableMapScene
extends Node2D

const SELECTED_MODULATE = Color(1.3,1.3,1.3,1)
const DESELECTED_MODULATE = Color(.8,.8,.8,.5)

@onready var sprite = $Sprite2D

var _texture: Texture

signal pressed

func _ready():
	sprite.texture = _texture

func use_texture(texture: Texture) -> void:
	_texture = texture
	if is_node_ready():
		sprite.texture = _texture

func _on_button_pressed():
	pressed.emit()

func select() -> void:
	sprite.modulate = SELECTED_MODULATE

func deselect() -> void:
	sprite.modulate = DESELECTED_MODULATE
