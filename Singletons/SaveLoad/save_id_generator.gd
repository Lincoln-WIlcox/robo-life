@tool
class_name SaveIdGenerator
extends Node

@export_file var save_id_sequence_path: String

func get_new_save_id() -> int:
	var save_file: FileAccess = FileAccess.open(save_id_sequence_path, FileAccess.READ_WRITE)
	
	var id: int
	if save_file.get_length() == 0:
		id = 0
	else:
		id = str_to_var(save_file.get_as_text()) + 1
	
	save_file.store_string(var_to_str(id))
	return id
