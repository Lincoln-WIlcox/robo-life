class_name PlayerLedgeGrabDetector
extends Node

@export var grab_left: Area2D
@export var grab_right: Area2D
@export var active := true
@export var player_shape: CollisionShape2D

var ledge: Ledge

signal ledge_grabbed(is_left_side: bool)

func _ready():
	grab_left.area_entered.connect(_on_grab_area_area_entered.bind(true))
	grab_right.area_entered.connect(_on_grab_area_area_entered.bind(false))

func _on_grab_area_area_entered(area: Area2D, on_left_side: bool):
	if area is Ledge and area.is_left_side != on_left_side:
		ledge = area
		if can_grab_ledge():
			ledge_grabbed.emit(ledge.is_left_side)

func can_grab_ledge() -> bool:
	var use_transform: Transform2D = grab_left.get_global_transform() if ledge.is_left_side else grab_right.get_global_transform()
	return ledge.can_fit_on_grab(player_shape.shape, use_transform)
