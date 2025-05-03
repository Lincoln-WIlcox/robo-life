extends Node2D

@export var speed_scale: int = 1

@onready var animatable_body: AnimatableBody2D = $AnimatableBody2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _moving_up: bool = true

func _ready():
	animation_player.play("Move")
	animation_player.speed_scale = speed_scale
