class_name World
extends Node2D

@onready var day_night_cycle = $DayNightCycle
@onready var player_character_controller = $PlayerCharacterController
@onready var tiles = $Tiles

@export var active_player: PlayerCharacterController:
	set(new_value):
		active_player = new_value
		active_player_changed.emit(active_player)
@export var shelter_item_grid: ItemGrid

signal player_died
signal active_player_changed(active_player: PlayerCharacterController)

func _ready():
	day_night_cycle.start_new_day()
	day_night_cycle.day_ended.connect(func(): player_died.emit())
