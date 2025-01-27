class_name HeatReceiver
extends Area2D

var receiving_heat := 0:
	set(new_value):
		if new_value > 0 and receiving_heat == 0:
			started_heating.emit()
		elif new_value == 0 and receiving_heat > 0:
			stopped_heating.emit()
		receiving_heat = new_value

signal new_heat_area(heat_area: HeatArea)
signal heat_area_left(heat_area: HeatArea)
signal started_heating
signal stopped_heating

func _physics_process(_delta):
	var heat_areas_overlapping: Array[Area2D] = get_overlapping_areas().filter(func(a: Area2D): return a is HeatArea)
	receiving_heat = heat_areas_overlapping.reduce(func(heat: int, heat_area: HeatArea): return heat + heat_area.heat_amount, 0)
	print(receiving_heat)

func is_being_heated() -> bool:
	return receiving_heat > 0

func _on_area_entered(area):
	if area is HeatArea:
		new_heat_area.emit(area)

func _on_area_exited(area):
	if area is HeatArea:
		heat_area_left.emit(area)
