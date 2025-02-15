class_name TransportBucketDestinationSelectionQueryableEntity
extends QueryableEntity

@export var selectable_map_entity: SelectableMapEntity

var power_connector: PowerConnector

signal map_entity_setup(map_entity: SelectableMapEntity)

func make_selectable_map_entity() -> SelectableMapEntity:
	var new_map_entity: SelectableMapEntity = selectable_map_entity.duplicate()
	new_map_entity.source_node = source_node
	new_map_entity.scene_setup.connect(map_entity_setup.emit.bind(new_map_entity))
	return new_map_entity
