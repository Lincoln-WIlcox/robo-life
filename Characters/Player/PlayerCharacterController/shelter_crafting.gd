extends State

@export var crafting_ui_packed_scene: PackedScene

var show_ui: Callable
var hide_ui: Callable
var player_inventory: Inventory
var shelter_inventory: Inventory

func enter():
	var crafting_ui = crafting_ui_packed_scene.instantiate()
	crafting_ui.player_inventory = player_inventory
	crafting_ui.shelter_inventory = shelter_inventory
	show_ui.call(crafting_ui)

func exit():
	hide_ui.call()
