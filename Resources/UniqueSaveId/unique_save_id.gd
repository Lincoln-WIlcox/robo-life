@tool
class_name UniqueSaveId
extends Resource

@export var save_id: int = -1
@export_tool_button("Generate ID", "Callable") var generate_id_tool: Callable = generate_id

func _init():
	if Engine.is_editor_hint() and save_id == -1:
		generate_id()

func is_id_generated() -> bool:
	return save_id != -1

func generate_id() -> void:
	var new_id: int = SaveLoad.get_save_id_generator().get_new_save_id()
	save_id = new_id
