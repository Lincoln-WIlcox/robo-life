extends State

@export var map_ui_packed_scene: PackedScene
@export var none_state: State
var toggle_map: Callable
var show_ui: Callable
var hide_ui: Callable
var get_map_data: Callable

var _map_ui: Map

func _ready():
	_map_ui = map_ui_packed_scene.instantiate()

func enter():
	var new_map_data: MapData = get_map_data.call()
	_map_ui.display_map_data(new_map_data)
	show_ui.call(_map_ui)

func run():
	if toggle_map.call():
		state_ended.emit(none_state)

func exit():
	hide_ui.call(false)
