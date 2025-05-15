@tool
extends Node

@onready var save_id_generator: SaveIdGenerator = $SaveIDGenerator

func get_save_id_generator() -> SaveIdGenerator:
	return save_id_generator
