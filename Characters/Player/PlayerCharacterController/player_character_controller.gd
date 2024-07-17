class_name PlayerCharacterController
extends Node2D

@onready var player_character = $PlayerCharacter
@onready var camera = $Camera2D
@onready var none_state: State = $UIStateMachine/None
@onready var pickup_stuff_handler: PickupStuffHandler = $PickupStuffHandler
@onready var inventory_state: State = $UIStateMachine/Inventory

@export var movement_disabled := false

signal item_dropped(drop: Object)
signal died

var inventory:
	get:
		return player_character.inventory

func _ready():
	player_character.is_jumping = func(): return Input.is_action_pressed("player_jump") and not movement_disabled
	player_character.is_moving_left = func(): return Input.is_action_pressed("player_move_left") and not movement_disabled
	player_character.is_moving_right = func(): return Input.is_action_pressed("player_move_right") and not movement_disabled
	player_character.just_jumped = func(): return Input.is_action_just_pressed("player_jump") and not movement_disabled
	player_character.is_moving_down = func(): return Input.is_action_pressed("player_move_down") and not movement_disabled
	player_character.is_moving_up = func(): return Input.is_action_pressed("player_move_up") and not movement_disabled
	player_character.is_climbing = func(): return Input.is_action_pressed("player_climb") and not movement_disabled
	player_character.just_climbed_callable = func(): return Input.is_action_just_pressed("player_climb") and not movement_disabled
	player_character.item_dropped.connect(func(drop: Object): item_dropped.emit(drop))
	player_character.died.connect(func(): died.emit())
	none_state.toggle_inventory = func(): return Input.is_action_just_pressed("toggle_inventory")
	pickup_stuff_handler.inventory = player_character.inventory
	pickup_stuff_handler.mouse_detect_area = player_character.mouse_detect_area
	inventory_state.active_player = player_character

func drop_item(item: ItemData):
	player_character.drop_item(item)

func _input(event):
	if event.is_action_pressed("player_interact") and not movement_disabled:
		player_character.just_interacted.emit()
	if event.is_action_pressed("player_climb") and not movement_disabled:
		player_character.just_climbed.emit()

func _process(delta):
	camera.position = player_character.character.position

func on_drop_item(item: ItemData):
	if item is PlaceableItemData:
		inventory_state.on_placeable_item_dropped(item)
	else:
		player_character.drop_item(item)
