extends Node2D

@onready var damage_receiver = $DamageReceiver

@export var max_heat := 1000
@export var cooldown_rate := 1

var heat = 0

signal max_heat_reached

func _physics_process(delta):
	heat += damage_receiver.receiving_damage if damage_receiver.receiving_damage else -cooldown_rate
	heat = max(heat, 0)
