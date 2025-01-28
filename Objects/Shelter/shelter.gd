extends Node2D

@export var level_map_map_entity_collection: MapEntityCollection
@export var map_scene: MapScene
@export var shelter_selection_map_scene: MapScene
@export var selectable_map_entity: SelectableMapEntity
@export var shelter_selection_texture: Texture

func _ready():
	if level_map_map_entity_collection:
		level_map_map_entity_collection.add_map_entity(map_scene)
	map_scene.scene_setup.connect(_set_map_entity_position)

func make_selectable_map_entity() -> SelectableMapEntity:
	var new_selectable_map_entity: SelectableMapEntity = selectable_map_entity.duplicate()
	new_selectable_map_entity.source_node = self
	new_selectable_map_entity.scene_setup.connect(_on_shelter_selectable_map_entity_scene_setup.bind(new_selectable_map_entity))
	return new_selectable_map_entity

func _set_map_entity_position() -> void:
	map_scene.instance.position = global_position

func _on_shelter_selectable_map_entity_scene_setup(map_entity: SelectableMapEntity) -> void:
	map_entity.instance.position = global_position
	map_entity.instance.use_texture(shelter_selection_texture)
