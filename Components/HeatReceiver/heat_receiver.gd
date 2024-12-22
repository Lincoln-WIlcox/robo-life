class_name HeatReceiver
extends Area2D

var receiving_heat = 0

signal new_heat_area(heat_area: HeatArea)

func _physics_process(_delta):
	var heat_areas_overlapping: Array[Area2D] = get_overlapping_areas().filter(func(a: Area2D): return a is HeatArea)
	receiving_heat = heat_areas_overlapping.reduce(func(heat: int, heat_area: HeatArea): return heat + heat_area.heat_amount, 0)

func _on_area_entered(area):
	if area is HeatArea:
		new_heat_area.emit(area)
