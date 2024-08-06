extends State

@export var crafting_ui_packed_scene: PackedScene

var show_ui: Callable
var hide_ui: Callable

func enter():
	var crafting_ui: Control = crafting_ui_packed_scene.instantiate()
	show_ui.call(crafting_ui)

func run():
	pass

func exit():
	hide_ui.call()
