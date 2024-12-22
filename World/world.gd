class_name World
extends Node2D

@onready var day_night_cycle = $DayNightCycle
@onready var player_character_controller = $PlayerCharacterController
@onready var tiles = $Tiles

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

func _ready():
	day_night_cycle.start_first_day()
	#day_night_cycle.day_ended.connect(func(): player_died.emit())
	player_character_controller.show_ui = show_ui
	player_character_controller.hide_ui = hide_ui
	player_character_controller.shelter_inventory = shelter_inventory
