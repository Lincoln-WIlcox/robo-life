class_name HeatReceiver
extends Area2D

var receiving_heat = 0

signal just_received_damage(damage: int)

func _physics_process(delta):
	var heat_areas_overlapping: Array[Area2D] = get_overlapping_areas().filter(func(a: Area2D): return a is HeatArea)
	receiving_heat = heat_areas_overlapping.reduce(func(heat: int, heat_area: HeatArea): return heat + heat_area.heat_amount, 0)

func _on_area_entered(area):
	if area is HeatArea:
		just_received_damage.emit(area.damage_amount)
