extends Node

const DEATH_MESSAGE = "You Died.. Bruh.."

@onready var hud: HUD = $UILayer/HUD
@onready var game_over_menu: GameOverMenu = $UILayer/GameOverMenu
@onready var inventory_gui = $UILayer/InventoryGUI

@export var ui_state_machine: StateMachine
@export var current_level_packed_scene: PackedScene
@export var inventory_state: State
@export var place_object_handler: PlaceObjectHandler
@export var placing_object_state: State

var world: World

func _ready():
	load_level(current_level_packed_scene)

func load_level(level: PackedScene) -> void:
	if world:
		world.queue_free()
	world = current_level_packed_scene.instantiate()
	add_child(world)
	world.player_died.connect(_on_world_day_ended)
	world.active_player_changed.connect(_on_active_player_changed)
	_on_active_player_changed(world.active_player)
	hud.time_left = func(): return round(world.day_night_cycle.get_time_left())
	place_object_handler.object_placed.connect(world.add_child)

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
	if not active_player.inventory.changed.is_connected(_on_active_player_inventory_changed):
		active_player.inventory.changed.connect(_on_active_player_inventory_changed.bind(active_player.inventory))
		inventory_state.get_active_player = func(): return active_player
		active_player.died.connect(
			func(): 
				world.call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
				game_over_menu.show_menu_with_death_message(DEATH_MESSAGE)
		)
		placing_object_state.item_placed.connect(active_player.inventory.remove_item)

func _on_active_player_inventory_changed(inventory: Inventory):
	hud.battery_quantity = inventory.batteries
	inventory_gui.use_inventory(inventory)
