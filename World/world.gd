class_name World
extends Node2D

@onready var day_night_cycle: DayNightCycle = $DayNightCycle
@onready var player_character_controller: PlayerCharacterController = $PlayerCharacterController
@onready var tiles: TileMapLayer = $Tiles
@onready var sector_handler = $SectorHandler
@onready var player_place_object_handler: PlayerPlaceObjectHandler = $PlayerPlaceObjectHandler
@onready var environment_query_system: EnvironmentQuerySystem = $EnvironmentQuerySystem

@export var active_player: PlayerCharacterController:
	set(new_value):
		active_player = new_value
		_active_player_changed()
		active_player_changed.emit(active_player)
@export var shelter_inventory: Inventory

signal active_player_changed(active_player: PlayerCharacterController)

var show_ui: Callable:
	set(new_value):
		show_ui = new_value
		if is_node_ready():
			player_character_controller.show_ui = show_ui
			player_place_object_handler.show_ui = show_ui
			player_place_object_handler.setup_context()
var hide_ui: Callable:
	set(new_value):
		hide_ui = new_value
		if is_node_ready():
			player_character_controller.hide_ui = hide_ui
			player_place_object_handler.hide_ui = hide_ui
			player_place_object_handler.setup_context()
var get_current_ui: Callable:
	set(new_value):
		get_current_ui = new_value
		
		if is_node_ready():
			player_character_controller.get_current_ui = get_current_ui
var win: Callable

func _ready():
	day_night_cycle.start_first_day()
	player_character_controller.show_ui = show_ui
	player_character_controller.hide_ui = hide_ui
	player_character_controller.shelter_inventory = shelter_inventory
	player_character_controller.get_revealed_sectors = get_revealed_sectors
	player_character_controller.reveal_sector = sector_handler.reveal_sector
	player_character_controller.setup_sectors()
	player_character_controller.start_placing_placeable = start_placing_placeable_by_player
	
	player_place_object_handler.can_place_items = active_player.can_place_items
	player_place_object_handler.cursor_detect_area = active_player.get_cursor_detect_area()
	player_place_object_handler.show_ui = show_ui
	player_place_object_handler.hide_ui = hide_ui
	player_place_object_handler.get_revealed_sectors = get_revealed_sectors
	player_place_object_handler.sector_revealed_signal = sector_handler.sector_revealed
	player_place_object_handler.setup_context()

func get_revealed_sectors() -> Array[Vector2i]:
	return sector_handler.revealed_sectors

func _active_player_changed() -> void:
	if is_node_ready():
		player_place_object_handler.can_place_items = active_player.can_place_items
		player_place_object_handler.cursor_detect_area = active_player.get_cursor_detect_area()

func _on_damaged_ship_parts_tracker_all_damaged_ship_parts_repaired():
	win.call()

func start_placing_placeable_by_player(placeable: Placeable) -> void:
	player_place_object_handler.start_placing_placeable(placeable)
