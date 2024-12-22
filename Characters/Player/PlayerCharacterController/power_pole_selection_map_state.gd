extends State

@export var map_ui_packed_scene: PackedScene
@export var none_state: State
var toggle_map: Callable
var show_ui: Callable
var hide_ui: Callable
var environment_query_system: EnvironmentQuerySystem

var _map_ui: PowerPoleSelectionMap
var _map_data: MapData

func _ready():
	_map_ui = map_ui_packed_scene.instantiate()
	_map_ui.power_pole_selected.connect(_on_map_ui_power_pole_selected)

func setup_map() -> void:
	_map_data = _get_map_data()
	environment_query_system.queryable_added.connect(_on_enviornment_query_system_queryable_added)
	_map_ui.display_map_data(_map_data)

func _get_map_data() -> MapData:
	var solidity_polygons: Array[PackedVector2Array] = environment_query_system.get_tile_maps_solidity()
	var bounding_box: Rect2 = environment_query_system.get_solidity_bounding_box()
	var power_pole_queryables: Array[QueryableEntity] = environment_query_system.get_queryables_by_class(PowerPole)
	var power_pole_map_entities_assigner: Array = power_pole_queryables.map(func(power_pole_queryable: QueryableEntity): return power_pole_queryable.source_node.power_pole_selection_map_entity)
	var power_pole_map_entities: Array[MapEntity]
	power_pole_map_entities.assign(power_pole_map_entities_assigner)
	var map_data: MapData = MapData.new(power_pole_map_entities, solidity_polygons, bounding_box)
	return map_data

func _on_enviornment_query_system_queryable_added(added_queryable: QueryableEntity) -> void:
	if added_queryable.source_node is PowerPole:
		_map_data.add_map_entity(added_queryable.source_node.power_pole_selection_map_entity)

#when is this getting called?
func _on_map_ui_power_pole_selected(_power_pole) -> void:
	state_ended.emit(none_state)
	_map_ui.reset_selected_power_pole()

func enter():
	show_ui.call(_map_ui)

func run():
	if toggle_map.call():
		state_ended.emit(none_state)

func exit():
	hide_ui.call(false)
