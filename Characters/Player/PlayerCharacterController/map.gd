extends State

@export var map_ui_packed_scene: PackedScene

var toggle_map: Callable
var show_ui: Callable
var hide_ui: Callable

var _map_ui: Map

func _ready():
	_map_ui = map_ui_packed_scene.instantiate()

func enter():
	show_ui.call(_map_ui)

func exit():
	hide_ui.call()
