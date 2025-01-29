class_name EntitySelectionMapDisplay
extends MapDisplay

var _selected_map_scene: SelectableMapScene

signal entity_selected(selectable_map_entity: SelectableMapEntity)

func _display_map_entity(map_entity: MapEntity) -> void:
	if map_entity is SelectableMapEntity:
		var selectable_map_scene: SelectableMapScene = _display_map_scene(map_entity)
		selectable_map_scene.pressed.connect(_on_selectable_map_scene_pressed.bind(selectable_map_scene, map_entity))
		return
	super(map_entity)

func _on_selectable_map_scene_pressed(selectable_map_scene: SelectableMapScene, map_entity: SelectableMapEntity) -> void:
	_update_selected_entity(selectable_map_scene)
	entity_selected.emit(map_entity)

func _update_selected_entity(new_selectable_mep_scene: SelectableMapScene) -> void:
	if _selected_map_scene:
		_selected_map_scene.deselect()
	_selected_map_scene = new_selectable_mep_scene
	_selected_map_scene.select()

func reset_selected_entity() -> void:
	if _selected_map_scene:
		_selected_map_scene.deselect()
	_selected_map_scene = null
