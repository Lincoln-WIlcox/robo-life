class_name Shield
extends Node2D

@onready var area = $Area2D

@export var max_energy := 100
@export var decrease_rate := 2
@export var increase_rate := 1

var energy := max_energy
var deployed := false:
	set(new_value):
		deployed = new_value
		if deployed:
			_on_deploy()
		else:
			_on_un_deploy()

func _physics_process(delta):
	if deployed:
		energy = max(energy - decrease_rate, 0)
	else:
		energy = min(energy + increase_rate, max_energy)
	if energy <= 0:
		un_deploy()

func deploy() -> void:
	deployed = true

func un_deploy() -> void:
	deployed = false

func _on_deploy() -> void:
	area.monitorable = true
	area.show()

func _on_un_deploy() -> void:
	area.monitorable = false
	area.hide()