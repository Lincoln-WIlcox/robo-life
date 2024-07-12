class_name WalkOverItemPickupArea
extends Area2D

@export var inventory_addition: InventoryAddition

signal collected

func collect():
	collected.emit()
	return inventory_addition
