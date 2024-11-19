extends Node

@export var health_component: HealthComponent
@export var gas_damage := 1

@onready var timer = $BetweenGasDamageTimer

func start_gassing():
	timer.start()

func end_gassing():
	timer.stop()

func _on_between_gas_damage_timer_timeout():
	health_component.take_damage(gas_damage)
