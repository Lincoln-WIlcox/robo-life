extends Node

@export var interaction_indicator: ColorRect
@export var interaction_area: Area2D

func _process(_delta):
	for area in interaction_area.get_overlapping_areas():
		if area is InteractionArea and area.disabled == false:
			interaction_indicator.show()
			return
	interaction_indicator.hide()
