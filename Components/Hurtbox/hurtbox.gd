class_name Hurtbox
extends Area2D

signal damage_received(amount: int)

var take_damage := true

func _on_area_entered(area):
	if area is Hitbox and take_damage:
		damage_received.emit(area.damage)

func check_for_damage():
	var hitboxes: Array[Area2D] = get_overlapping_areas().filter(func(area): return area is Hitbox)
	var highest_damage = hitboxes.reduce(func(agg, hitbox: Hitbox): return max(agg, hitbox.damage), -INF)
	var hitboxes_with_highest_damage: Array[Area2D] = hitboxes.filter(func(hitbox: Hitbox): return hitbox.damage >= highest_damage)
	
	if hitboxes_with_highest_damage.size() > 0:
		damage_received.emit(hitboxes_with_highest_damage[0].damage)
