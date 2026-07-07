class_name CollectableSaveComponent
extends Node

@export var unique_save_id: UniqueSaveId

signal loading_collected_collectable
signal loading_uncollected_collectable

var _session_collected: bool = false

func _ready():
	SaveLoad.game_loaded.connect(_on_game_loaded)

func set_collected(new_collected: bool) -> void:
	_session_collected = new_collected
	SaveLoad.get_save_data().set_id_collected(unique_save_id.save_id, new_collected)

func is_collected() -> bool:
	return SaveLoad.get_save_data().is_id_collected(unique_save_id.save_id)

func _on_game_loaded() -> void:
	if is_collected() and not _session_collected:
		loading_collected_collectable.emit()
	elif not is_collected() and _session_collected:
		loading_uncollected_collectable.emit()
