extends State

@export var crafting_ui_packed_scene: PackedScene
@export var shelter_state: State

var show_ui: Callable
var hide_ui: Callable
var player_inventory: Inventory
var shelter_inventory: Inventory

func enter():
	var crafting_ui = crafting_ui_packed_scene.instantiate()
	crafting_ui.player_inventory = player_inventory
	crafting_ui.shelter_inventory = shelter_inventory
	crafting_ui.return_pressed.connect(_on_return_pressed)
	show_ui.call(crafting_ui)

func exit():
	hide_ui.call()

func _on_return_pressed():
	state_ended.emit(shelter_state)
