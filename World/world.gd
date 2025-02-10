class_name World
extends Node2D

@onready var day_night_cycle: DayNightCycle = $DayNightCycle
@onready var player_character_controller: PlayerCharacterController = $PlayerCharacterController
@onready var tiles: TileMapLayer = $Tiles
@onready var sector_handler = $SectorHandler

@export var active_player: PlayerCharacterController:
	set(new_value):
		active_player = new_value
		active_player_changed.emit(active_player)
@export var shelter_inventory: Inventory

signal active_player_changed(active_player: PlayerCharacterController)

var show_ui: Callable:
	set(new_value):
		show_ui = new_value
		if is_node_ready():
			player_character_controller.show_ui = show_ui
var hide_ui: Callable:
	set(new_value):
		hide_ui = new_value
		if is_node_ready():
			player_character_controller.hide_ui = hide_ui
var get_current_ui: Callable:
	set(new_value):
		get_current_ui = new_value
		
		if is_node_ready():
			player_character_controller.get_current_ui = get_current_ui
var win: Callable:
	set(new_value):
		win = new_value
		if is_node_ready():
			pass

func _ready():
	day_night_cycle.start_first_day()
	player_character_controller.show_ui = show_ui
	player_character_controller.hide_ui = hide_ui
	player_character_controller.shelter_inventory = shelter_inventory
	player_character_controller.get_revealed_sectors = func() -> Array[Vector2i]: return sector_handler.revealed_sectors
	player_character_controller.reveal_sector = sector_handler.reveal_sector
	player_character_controller.setup_sectors()
