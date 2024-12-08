class_name TransportBucket
extends Node2D

@export var initial_inventory: Inventory

var _inventory: Inventory

func _ready():
	initial_inventory = _inventory
