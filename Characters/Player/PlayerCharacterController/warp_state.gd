extends State

@export var shelter_warp_ui_packed_scene: PackedScene
@export var none_state: State
@export var shelter_state: State

var environment_query_system: EnvironmentQuerySystem
var show_ui: Callable
var hide_ui: Callable

var _shelter_warp_ui: ShelterWarpUI
var _map_data: MapData

func _ready():
	_shelter_warp_ui = shelter_warp_ui_packed_scene.instantiate()
	_shelter_warp_ui.shelter_selected.connect(_on_shelter_warp_ui_shelter_selected)
	_shelter_warp_ui.cancelled.connect(_on_return_pressed)

func setup_map() -> void:
	_map_data = _get_map_data()
	environment_query_system.queryable_added.connect(_on_enviornment_query_system_queryable_added)
	_shelter_warp_ui.display_map_data(_map_data)

func enter():
	show_ui.call(_shelter_warp_ui)

func exit():
	hide_ui.call()

func _get_map_data() -> MapData:
	var solidity_polygons: Array[PackedVector2Array] = environment_query_system.get_tile_maps_solidity()
	var bounding_box: Rect2 = environment_query_system.get_solidity_bounding_box()
	var power_pole_queryables: Array[QueryableEntity] = environment_query_system.get_queryables_by_class(PowerPole)
	var power_pole_map_entities_assigner: Array = power_pole_queryables.map(func(power_pole_queryable: QueryableEntity): return power_pole_queryable.source_node.power_pole_selection_map_entity)
	var power_pole_map_entities: Array[MapEntity]
	power_pole_map_entities.assign(power_pole_map_entities_assigner)
	var map_data: MapData = MapData.new(power_pole_map_entities, solidity_polygons, bounding_box)
	return map_data

func _on_shelter_warp_ui_shelter_selected(_shelter) -> void:
	if is_current_state.call():
		state_ended.emit(none_state)
		_shelter_warp_ui.reset_selected_shelter()

func _on_enviornment_query_system_queryable_added(added_queryable: QueryableEntity) -> void:
	if added_queryable.source_node is PowerPole:
		_map_data.add_map_entity(added_queryable.source_node.power_pole_selection_map_entity)

func _on_return_pressed() -> void:
	if is_current_state.call():
		state_ended.emit(shelter_state)
