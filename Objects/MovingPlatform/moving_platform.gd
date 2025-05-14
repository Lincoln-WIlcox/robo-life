@tool
extends Node2D

@export var speed_scale: float = 1:
	set(new_value):
		speed_scale = new_value
		if is_node_ready():
			_update_speed_scale()
@export var height: int = 16:
	set(new_value):
		height = new_value
		if is_node_ready():
			_update_path_height()
@export var tile_height: float = 1:
	set(new_value):
		height = new_value * 16
	get:
		return float(height) / 16.0

@onready var animatable_body: AnimatableBody2D = $AnimatableBody2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var path: Path2D = $Path2D

var _moving_up: bool = true

func _ready():
	_update_path_height()
	_update_speed_scale()
	animation_player.play("Move")

func _update_path_height() -> void:
	var point_pos: Vector2 = Vector2(0, -height)
	path.curve.set_point_position(1, point_pos)

func _update_speed_scale() -> void:
	animation_player.speed_scale = speed_scale
