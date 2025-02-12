extends Node

signal map_entity_added(map_entity: MapEntity)

func emit_map_entity_added(map_entity: MapEntity) -> void:
	map_entity_added.emit(map_entity)
