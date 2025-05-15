class_name SaveData
extends Resource

var collected_ids: Dictionary[int, bool]

static func from_dict(data: Dictionary) -> SaveData:
	var save_data: SaveData = SaveData.new()
	save_data.collected_ids = data["CollectedIds"]
	return save_data

func set_id_collected(id: int, collected: bool) -> void:
	collected_ids[id] = collected

func is_id_collected(id: int) -> bool:
	return collected_ids[id] if collected_ids.has(id) else false

func data_as_dict() -> Dictionary:
	return {"CollectedIds": collected_ids}
