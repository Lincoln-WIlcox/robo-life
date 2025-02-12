class_name MapEntityCollection
extends Node

@export var _map_entities: Array[MapEntity]

signal map_entity_added(map_entity: MapEntity)
signal map_entity_removed(map_entity: MapEntity)

func _ready():
	EventBus.map_entity_added.connect(add_map_entity)

func add_map_entity(map_entity: MapEntity) -> void:
	_map_entities.append(map_entity)
	map_entity_added.emit(map_entity)
	map_entity.source_removed.connect(remove_map_entity.bind(map_entity))

func get_map_entities() -> Array[MapEntity]:
	return _map_entities

func remove_map_entity(map_entity: MapEntity) -> void:
	_map_entities.erase(map_entity)
	map_entity_removed.emit(map_entity)
