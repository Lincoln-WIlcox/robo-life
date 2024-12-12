class_name PlayerCharacterController
extends Node2D

@onready var player_character = $PlayerCharacter
@onready var camera = $Camera2D
@onready var none_state: State = $UIStateMachine/None
@onready var pickup_stuff_handler: PickupStuffHandler = $PickupStuffHandler
@onready var inventory_state: State = $UIStateMachine/Inventory
@onready var placing_object_state: State = $UIStateMachine/PlacingObject
@onready var shelter_state: State = $UIStateMachine/Shelter
@onready var place_object_handler: PlaceObjectHandler = $PlaceObjectHandler
@onready var laser_gun = $LaserGun
@onready var laser_gun_handler = $PlayerLaserGunHandler
@onready var crafting_state = $UIStateMachine/Shelter/ShelterStateMachine/Crafting
@onready var shelter_shelter_state = $UIStateMachine/Shelter/ShelterStateMachine/Shelter
@onready var player_shield_handler = $PlayerShieldHandler
@onready var level_map_state = $UIStateMachine/LevelMap
@onready var map_texture_updater = $MapTextureUpdater
@onready var power_pole_placement_handler = $PowerPolePlacementHandler
@onready var power_pole_selection_map = $UIStateMachine/PowerPoleSelectionMap
@onready var transport_bucket_placement_handler = $TransportBucketPlacementHandler
@onready var cursor_interaction_handler = $CursorInteractionHandler

@export var map_texture: MapTexture
@export var movement_disabled := false
@export var node_to_spawn_placeables_in: Node
@export var shelter_inventory: Inventory:
	set(new_value):
		shelter_inventory = new_value
		shelter_shelter_state.shelter_inventory = shelter_inventory
		crafting_state.shelter_inventory = shelter_inventory
@export var environment_query_system: EnvironmentQuerySystem
@export var level_map_map_entity_collection: MapEntityCollection

var inventory:
	get:
		return player_character.inventory

var show_ui: Callable:
	set(new_value):
		show_ui = new_value
		if is_node_ready():
			inventory_state.show_ui = show_ui
			shelter_shelter_state.show_ui = show_ui
			crafting_state.show_ui = show_ui
			level_map_state.show_ui = show_ui
			power_pole_selection_map.show_ui = show_ui
			transport_bucket_placement_handler.show_ui = show_ui
var hide_ui: Callable:
	set(new_value):
		hide_ui = new_value
		if is_node_ready():
			inventory_state.hide_ui = hide_ui
			shelter_shelter_state.hide_ui = hide_ui
			crafting_state.hide_ui = hide_ui
			level_map_state.hide_ui = hide_ui
			power_pole_selection_map.hide_ui = hide_ui
			transport_bucket_placement_handler.hide_ui = hide_ui

signal item_dropped(drop: Object)
signal died
signal inventory_opened(inventory_ui: Control)
signal inventory_closed
signal shelter_opened(shelter_ui: Control)
signal shelter_closed
signal day_ended

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
	pickup_stuff_handler.inventory = inventory
	pickup_stuff_handler.mouse_detect_area = player_character.mouse_detect_area
	inventory_state.active_player = player_character
	inventory_state.toggle_inventory = func(): return Input.is_action_just_pressed("toggle_inventory")
	placing_object_state.place_object = func(): return Input.is_action_just_pressed("place_object")
	placing_object_state.cancel_placing_object = func(): return Input.is_action_just_pressed("cancel_placing_object")
	placing_object_state.inventory = inventory
	pickup_stuff_handler.pickup = func(): return Input.is_action_just_pressed("pickup")
	pickup_stuff_handler.mouse_detect_area = player_character.mouse_detect_area
	pickup_stuff_handler.inventory = inventory
	place_object_handler.mouse_detect_area = player_character.mouse_detect_area
	place_object_handler.node_to_spawn_placeables_in = node_to_spawn_placeables_in
	laser_gun_handler.is_firing = func(): return Input.is_action_pressed("fire")
	inventory_state.inventory_opened.connect(func(): inventory_opened.emit())
	inventory_state.inventory_closed.connect(func(): inventory_closed.emit())
	inventory_state.inventory = inventory
	shelter_state.interaction_area = player_character.interaction_area
	crafting_state.player_inventory = inventory
	shelter_shelter_state.shelter_opened.connect(func(): shelter_opened.emit())
	shelter_shelter_state.shelter_closed.connect(func(): shelter_closed.emit())
	shelter_shelter_state.shelter_inventory = shelter_inventory
	shelter_shelter_state.inventory = inventory
	player_shield_handler.just_started_shielding = func(): return Input.is_action_just_pressed("shield")
	player_shield_handler.just_stopped_shielding = func(): return Input.is_action_just_released("shield")
	player_shield_handler.player_character = player_character.character
	player_shield_handler.shield_progress_bar = player_character.shield_progress_bar
	none_state.toggle_map = func(): return Input.is_action_just_pressed("toggle_map")
	none_state.toggle_power_pole_selection_map = func(): return Input.is_action_just_pressed("test_input")
	none_state.is_firing = func(): return Input.is_action_pressed("fire")
	none_state.toggle_inventory = func(): return Input.is_action_just_pressed("toggle_inventory")
	power_pole_placement_handler.enviornment_query_system = environment_query_system
	power_pole_selection_map.toggle_map = func(): return Input.is_action_just_pressed("test_input")
	power_pole_selection_map.environment_query_system = environment_query_system
	power_pole_selection_map.setup_map()
	level_map_map_entity_collection.add_map_entity(map_texture)
	level_map_state.toggle_map = func(): return Input.is_action_just_pressed("toggle_map")
	level_map_state.environment_query_system = environment_query_system
	level_map_state.map_entity_collection = level_map_map_entity_collection
	level_map_state.setup_map()
	map_texture.get_position = func(): return player_character.character.global_position
	map_texture.source_node = self
	transport_bucket_placement_handler.node_to_put_transport_buckets_in = node_to_spawn_placeables_in
	transport_bucket_placement_handler.show_ui = show_ui
	transport_bucket_placement_handler.hide_ui = hide_ui
	transport_bucket_placement_handler.environment_query_system = environment_query_system
	cursor_interaction_handler.mouse_detect_area = player_character.mouse_detect_area
	cursor_interaction_handler.cursor_interacted = func(): return Input.is_action_just_pressed("cursor_interact")
	
	map_texture_updater.map_texture = map_texture
	
	remove_child(laser_gun)
	player_character.character.add_child(laser_gun)

func drop_item(item: ItemData):
	player_character.drop_item(item)

func _input(event):
	if event.is_action_pressed("player_interact") and not movement_disabled:
		player_character.just_interacted.emit()
	if event.is_action_pressed("player_climb") and not movement_disabled:
		player_character.just_climbed.emit()
	if event.is_action_pressed("toggle_inventory"):
		shelter_state.on_shelter_closed()

func _process(_delta):
	camera.position = player_character.character.position

func handle_drop_item(grid_item: ItemGridItem):
	if grid_item.item_data is PlaceableItemData:
		inventory_state.on_placeable_item_dropped(grid_item)
	else:
		player_character.drop_item(grid_item)

func on_shelter_closed():
	shelter_state.on_shelter_closed()

func _on_shelter_day_ended():
	day_ended.emit()

func _on_day_night_cycle_day_started(_day):
	shelter_inventory.change_food(-Utils.AMOUNT_OF_FOOD_TO_CONSUME)
	player_character.stop_gassing()

func _on_day_night_cycle_day_ended():
	player_character.start_gassing()
