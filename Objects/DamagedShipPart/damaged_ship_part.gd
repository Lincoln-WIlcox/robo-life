class_name DamagedShipPart
extends Node2D

var _is_repaired: bool = false

signal repaired
signal unrepaired

func get_repaired() -> bool:
	return _is_repaired
