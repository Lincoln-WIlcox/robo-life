@tool
extends Node

const SAVE_FILE_PATH: String = "user://savegame.save"

@onready var save_id_generator: SaveIdGenerator = $SaveIDGenerator

var using_save_data: SaveData

signal game_loaded

func get_save_id_generator() -> SaveIdGenerator:
	return save_id_generator

func save_game() -> void:
	var save_file: FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var data = using_save_data.data_as_dict()
	var json_string: String = var_to_str(data)
	save_file.store_string(json_string)

func load_game() -> SaveData:
	var new_save_data: SaveData
	
	var load_success: bool = false
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var save_file: FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if save_file.get_length() > 0:
			var data = str_to_var(save_file.get_as_text())
			new_save_data = SaveData.from_dict(data)
			load_success = true
	
	if not load_success:
		new_save_data = SaveData.new()
	
	using_save_data = new_save_data
	game_loaded.emit()
	return new_save_data

func get_save_data() -> SaveData:
	if using_save_data != null:
		return using_save_data
	else:
		return load_game()
