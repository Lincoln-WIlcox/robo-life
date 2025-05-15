@tool
extends Node

@export var save_id: int = -1
@export_tool_button("Generate ID", "Callable") var generate_id_tool: Callable = generate_id

func _ready():
	if save_id == null:
		generate_id()

func generate_id() -> void:
	var new_id: int = SaveLoad.get_save_id_generator().get_new_save_id()
	save_id = new_id
