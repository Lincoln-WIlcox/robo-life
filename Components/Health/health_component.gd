class_name HealthComponent
extends Node

@export var max_health = 10
@export var health = max_health:
	set(new_value):
		if new_value > health:
			healed.emit(health - new_value)
		elif new_value < health:
			damage_taken.emit(health - new_value)
		if new_value != health:
			health_changed.emit(new_value)
		if new_value <= 0:
			health_reached_zero.emit()
		
		health = new_value

signal health_reached_zero
signal health_changed(health: int)
signal damage_taken(health_lost: int)
signal healed(health_gained: int)

func take_damage(amount: int):
	health -= amount

func heal(amount: int):
	health += amount
