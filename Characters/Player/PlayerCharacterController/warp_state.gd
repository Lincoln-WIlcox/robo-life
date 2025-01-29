extends State

@export var shelter_warp_ui_packed_scene: PackedScene
@export var none_state: State
@export var shelter_state: State

var environment_query_system: EnvironmentQuerySystem
var show_ui: Callable
var hide_ui: Callable

var _shelter_warp_ui: ShelterWarpUI
var _map_data: MapData

var _shelters_interacted_with: Array[Shelter]

signal shelter_selected(shelter: Shelter)

func _ready():
	_shelter_warp_ui = shelter_warp_ui_packed_scene.instantiate()
	_shelter_warp_ui.cancelled.connect(_on_return_pressed)

func setup_map() -> void:
	_map_data = _get_map_data()
	_shelter_warp_ui.display_map_data(_map_data)

func enter():
	show_ui.call(_shelter_warp_ui)

func exit():
	hide_ui.call()
	_shelter_warp_ui.reset_selected_shelter()

func _get_map_data() -> MapData:
	var solidity_polygons: Array[PackedVector2Array] = environment_query_system.get_tile_maps_solidity()
	var bounding_box: Rect2 = environment_query_system.get_solidity_bounding_box()
	var map_data: MapData = MapData.new([], solidity_polygons, bounding_box)
	return map_data

func _on_shelter_warp_ui_shelter_selected(_shelter) -> void:
	if is_current_state.call():
		state_ended.emit(none_state)
		_shelter_warp_ui.reset_selected_shelter()

func _on_return_pressed() -> void:
	if is_current_state.call():
		state_ended.emit(shelter_state)

func _on_shelter_selectable_selected(shelter: Shelter) -> void:
	shelter_selected.emit(shelter)
	state_ended.emit(none_state)

func _on_player_character_shelter_interacted_with(shelter_area: ShelterInteractionArea) -> void:
	var shelter: Shelter = shelter_area.shelter
	if not _shelters_interacted_with.has(shelter):
		_shelters_interacted_with.append(shelter)
		var selectable_map_entity: SelectableMapEntity = shelter.make_selectable_map_entity()
		_map_data.add_map_entity(selectable_map_entity)
		selectable_map_entity.selected.connect(_on_shelter_selectable_selected.bind(shelter))
