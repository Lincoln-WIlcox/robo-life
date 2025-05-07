extends Node

const DEATH_MESSAGE = "You Died.. Bruh.."

@onready var hud: HUD = $UILayer/HUD
@onready var game_over_menu: GameOverMenu = $UILayer/GameOverMenu
@onready var UILayer = $UILayer
@onready var win_screen = $UILayer/WinScreen

@export var ui_state_machine: StateMachine
@export var current_level_packed_scene: PackedScene
@export var inventory_state: State
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
	world.active_player_changed.connect(_on_active_player_changed)
	_on_active_player_changed(world.active_player)
	hud.time_left = func(): return round(world.day_night_cycle.get_time_left())
	world.show_ui = UILayer.show_ui
	world.hide_ui = UILayer.hide_ui
	world.get_current_ui = UILayer.get_current_ui
	world.win = win

func game_over() -> void:
	_end_game()
	game_over_menu.show_menu_with_death_message(DEATH_MESSAGE)

func win() -> void:
	_end_game()
	win_screen.show()

func _end_game() -> void:
	world.call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)

func _on_world_day_ended():
	game_over()

func _on_game_over_menu_play_again_pressed():
	game_over_menu.hide()
	load_level(current_level_packed_scene)

func _on_active_player_changed(active_player: PlayerCharacterController):
	active_player.died.connect(_on_world_day_ended)

func _on_active_player_inventory_changed(inventory: Inventory):
	hud.battery_quantity = inventory.batteries.value
