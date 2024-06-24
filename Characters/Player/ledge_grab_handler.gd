class_name PlayerLedgeGrabDetector
extends Node

@export var grab_left: Area2D
@export var grab_right: Area2D
@export var active := true

var ledge: Ledge

signal ledge_grabbed(is_left_side: bool)

func _ready():
	grab_left.area_entered.connect(_on_grab_area_area_entered.bind(true))
	grab_right.area_entered.connect(_on_grab_area_area_entered.bind(false))

func _on_grab_area_area_entered(area: Area2D, on_left_side: bool):
	if area is Ledge and area.is_left_side != on_left_side:
		ledge = area
		ledge_grabbed.emit(ledge.is_left_side)
