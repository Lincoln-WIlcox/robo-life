extends Node2D

const FULL_HEAT_COLOR = Color(1,0,0)
const INITIAL_COLOR = Color(0.576, 0.373, 1)

@onready var color_rect = $ColorRect
@onready var overheater = $Overheater

func _on_overheater_max_heat_reached():
	queue_free()

func _process(_delta):
	color_rect.color = INITIAL_COLOR.lerp(FULL_HEAT_COLOR, remap(overheater.heat, 0, overheater.max_heat, 0, 1))
