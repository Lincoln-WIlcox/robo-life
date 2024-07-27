extends Node

const DEATH_MESSAGE = "You Died.. Bruh.."

@onready var hud: HUD = $UILayer/HUD
@onready var game_over_menu: GameOverMenu = $UILayer/GameOverMenu
@onready var inventory_gui: ItemGridInterface = $UILayer/ItemGridInterface
@onready var shelter_ui = $UILayer/ShelterUI

@export var ui_state_machine: StateMachine
@export var current_level_packed_scene: PackedScene
@export var inventory_state: State
@export var place_object_handler: PlaceObjectHandler
@export var placing_object_state: State
@export var pickup_stuff_handler: PickupStuffHandler

var world: World

func _ready():
	load_level(current_level_packed_scene)

func load_level(_level: PackedScene) -> void:
	current_level_packed_scene = _level
	if world:
		world.queue_free()
	world = current_level_packed_scene.instantiate()
	add_child(world)
	world.player_died.connect(_on_world_day_ended)
	world.active_player_changed.connect(_on_active_player_changed)
	_on_active_player_changed(world.active_player)
	hud.time_left = func(): return round(world.day_night_cycle.get_time_left())
	#place_object_handler.placing_item.connect(world.add_child)

#func _open_inventory_gui() -> void:
	#inventory_gui.open_gui()
	#world.active_player.movement_disabled = true
#
#func _close_inventory_gui() -> void:
	#inventory_gui.close_gui()
	#world.active_player.movement_disabled = false

func _on_world_day_ended():
	world.call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
	game_over_menu.show_menu_with_death_message(DEATH_MESSAGE)

func _on_game_over_menu_play_again_pressed():
	game_over_menu.hide()
	load_level(current_level_packed_scene)

func _on_active_player_changed(active_player: PlayerCharacterController):
	#inventory_state.get_active_player = func(): return active_player
	active_player.died.connect(
		func(): 
			world.call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
			game_over_menu.show_menu_with_death_message(DEATH_MESSAGE)
	)
	if not active_player.inventory_opened.is_connected(inventory_gui.open_gui):
		active_player.inventory_opened.connect(inventory_gui.open_gui)
	if not active_player.inventory_closed.is_connected(inventory_gui.close_gui):
		active_player.inventory_closed.connect(inventory_gui.close_gui)
	if not inventory_gui.item_dropped.is_connected(active_player.handle_drop_item):
		inventory_gui.item_dropped.connect(active_player.handle_drop_item)
	inventory_gui.item_grid = active_player.inventory.item_grid
	shelter_ui.item_grid_two = active_player.inventory.item_grid
	#placing_object_state.item_placed.connect(active_player.inventory.remove_item)
	#place_object_handler.mouse_detect_area = active_player.mouse_detect_area
	#pickup_stuff_handler.mouse_detect_area = active_player.mouse_detect_area
	#pickup_stuff_handler.inventory = active_player.inventory

func _on_active_player_inventory_changed(inventory: Inventory):
	hud.battery_quantity = inventory.batteries
	inventory_gui.update_grid()
