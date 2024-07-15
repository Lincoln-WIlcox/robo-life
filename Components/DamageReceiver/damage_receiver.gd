class_name DamageReceiver
extends Area2D

var receiving_damage = 0

signal just_received_damage(damage: int)

func _physics_process(delta):
	var damage_areas_overlapping: Array[Area2D] = get_overlapping_areas().filter(func(a: Area2D): return a is DamageArea)
	receiving_damage = damage_areas_overlapping.reduce(func(damage: int, damage_area: DamageArea): return damage + damage_area.damage_amount, 0)

func _on_area_entered(area):
	if area is DamageArea:
		just_received_damage.emit(area.damage_amount)
