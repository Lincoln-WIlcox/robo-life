class_name PlayerCharacterController
extends Node2D

@onready var player_character = $PlayerCharacter
@onready var camera = $Camera2D
@onready var none_state: State = $UIStateMachine/None
@onready var other_state: State = $UIStateMachine/Other
@onready var pickup_stuff_handler: PickupStuffHandler = $PickupStuffHandler
@onready var inventory_state: State = $UIStateMachine/Inventory
@onready var placing_object_state: State = $UIStateMachine/PlacingObject
@onready var shelter_state: State = $UIStateMachine/Shelter
@onready var laser_gun = $LaserGun
@onready var laser_gun_handler = $PlayerLaserGunHandler
@onready var crafting_state = $UIStateMachine/Shelter/ShelterStateMachine/Crafting
@onready var shelter_shelter_state = $UIStateMachine/Shelter/ShelterStateMachine/Shelter
@onready var player_shield_handler = $PlayerShieldHandler
@onready var level_map_state = $UIStateMachine/LevelMap
@onready var map_texture_updater = $MapTextureUpdater
#@onready var power_pole_selection_state = $UIStateMachine/TransportBucketDestinationSelectionMap
@onready var cursor_interaction_handler = $CursorInteractionHandler
@onready var shield = $ShieldRotationPivot/Shield
@onready var warp_state = $UIStateMachine/Shelter/ShelterStateMachine/Warp
@onready var shelter_warp_handler = $ShelterWarpHandler
@onready var sector_handler = $SectorHandler
@onready var debug_handler = $DebugHandler

@export var map_texture: MapTexture
@export var movement_disabled := false
@export var node_to_spawn_placeables_in: Node
@export var shelter_inventory: Inventory:
	set(new_value):
		shelter_inventory = new_value
		if is_node_ready():
			shelter_shelter_state.shelter_inventory = shelter_inventory
			crafting_state.shelter_inventory = shelter_inventory
@export var environment_query_system: EnvironmentQuerySystem
@export var level_map_map_entity_collection: MapEntityCollection = MapEntityCollection.new()
@export var transport_bucket_item: ItemData

var _queryable: PlayerQueryable = PlayerQueryable.new()

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
			#power_pole_selection_state.show_ui = show_ui
			warp_state.show_ui = show_ui
var hide_ui: Callable:
	set(new_value):
		hide_ui = new_value
		if is_node_ready():
			inventory_state.hide_ui = hide_ui
			shelter_shelter_state.hide_ui = hide_ui
			crafting_state.hide_ui = hide_ui
			level_map_state.hide_ui = hide_ui
			#power_pole_selection_state.hide_ui = hide_ui
			warp_state.hide_ui = hide_ui
var get_current_ui: Callable:
	set(new_value):
		get_current_ui = new_value
		if is_node_ready():
			none_state.get_current_ui = get_current_ui
			other_state.get_current_ui = get_current_ui
var get_revealed_sectors: Callable:
	set(new_value):
		get_revealed_sectors = new_value
		if is_node_ready():
			sector_handler.get_revealed_sectors = get_revealed_sectors
			level_map_state.get_revealed_sectors = get_revealed_sectors
			warp_state.get_revealed_sectors = get_revealed_sectors
			#power_pole_selection_state.get_revealed_sectors = get_revealed_sectors
var reveal_sector: Callable:
	set(new_value):
		reveal_sector = new_value
		if is_node_ready():
			sector_handler.reveal_sector = reveal_sector
var start_placing_placeable: Callable:
	set(new_value):
		start_placing_placeable = new_value
		placing_object_state.start_placing_placeable = start_placing_placeable

signal item_dropped(drop: Object)
signal died
signal inventory_opened(inventory_ui: Control)
signal inventory_closed
signal shelter_opened(shelter_ui: Control)
signal shelter_closed
signal day_ended
signal place_placeable_pressed
signal cancel_placing_placeable_pressed

var shelter_map_scenes_interacted_with: Array[ShelterInteractionArea]

func _ready():
	EventBus.emit_map_entity_added(map_texture)
	
	_queryable.connect_source(self)
	_queryable.player_inventory = inventory
	environment_query_system.add_entity_queryable(_queryable)
	
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
	player_character.node_to_put_drops_in = node_to_spawn_placeables_in
	pickup_stuff_handler.inventory = inventory
	pickup_stuff_handler.cursor_detect_area = player_character.cursor_detect_area
	inventory_state.active_player = player_character
	inventory_state.toggle_inventory = func(): return Input.is_action_just_pressed("toggle_inventory")
	placing_object_state.place_object = func(): return Input.is_action_just_pressed("place_object")
	placing_object_state.inventory = inventory
	placing_object_state.start_placing_placeable = start_placing_placeable
	pickup_stuff_handler.pickup = func(): return Input.is_action_just_pressed("pickup")
	pickup_stuff_handler.cursor_detect_area = player_character.cursor_detect_area
	pickup_stuff_handler.inventory = inventory
	laser_gun_handler.is_firing = func(): return Input.is_action_pressed("fire")
	inventory_state.inventory_opened.connect(func(): inventory_opened.emit())
	inventory_state.inventory_closed.connect(func(): inventory_closed.emit())
	inventory_state.setup_ui(inventory)
	shelter_state.interaction_area = player_character.interaction_area
	crafting_state.player_inventory = inventory
	crafting_state.shelter_inventory = shelter_inventory
	crafting_state.setup_ui()
	shelter_shelter_state.shelter_opened.connect(func(): shelter_opened.emit())
	shelter_shelter_state.shelter_closed.connect(func(): shelter_closed.emit())
	shelter_shelter_state.shelter_inventory = shelter_inventory
	shelter_shelter_state.inventory = inventory
	shelter_shelter_state.setup_ui()
	player_shield_handler.just_started_shielding = func(): return Input.is_action_just_pressed("shield")
	player_shield_handler.just_stopped_shielding = func(): return Input.is_action_just_released("shield")
	player_shield_handler.player_character = player_character.character
	player_shield_handler.shield_progress_bar = player_character.shield_progress_bar
	none_state.toggle_map = func(): return Input.is_action_just_pressed("toggle_map")
	none_state.toggle_power_pole_selection = func(): return false #Input.is_action_just_pressed("test_input")
	none_state.is_firing = func(): return Input.is_action_pressed("fire")
	none_state.toggle_inventory = func(): return Input.is_action_just_pressed("toggle_inventory")
	#power_pole_selection_state.toggle_map = func(): return Input.is_action_just_pressed("test_input")
	#power_pole_selection_state.environment_query_system = environment_query_system
	#power_pole_selection_state.get_revealed_sectors = get_revealed_sectors
	level_map_state.toggle_map = func(): return Input.is_action_just_pressed("toggle_map")
	level_map_state.environment_query_system = environment_query_system
	level_map_state.map_entity_collection = level_map_map_entity_collection
	level_map_state.get_revealed_sectors = get_revealed_sectors
	map_texture.get_position = func(): return player_character.character.global_position
	map_texture.source_node = self
	cursor_interaction_handler.cursor_detect_area = player_character.cursor_detect_area
	cursor_interaction_handler.cursor_interacted = func(): return Input.is_action_just_pressed("cursor_interact")
	other_state.toggle_inventory = func(): return Input.is_action_just_pressed("toggle_inventory")
	other_state.toggle_map = func(): return Input.is_action_just_pressed("toggle_map")
	other_state.toggle_power_pole_selection = func(): return false #Input.is_action_just_pressed("test_input")
	map_texture_updater.map_texture = map_texture
	warp_state.environment_query_system = environment_query_system
	warp_state.get_revealed_sectors = get_revealed_sectors
	shelter_warp_handler.player_character = player_character.character
	sector_handler.player_body = player_character.character
	sector_handler.get_revealed_sectors = get_revealed_sectors
	sector_handler.reveal_sector = reveal_sector
	debug_handler.player_inventory = player_character.inventory
	
	remove_child(laser_gun)
	player_character.character.add_child(laser_gun)
	laser_gun.laser.raycast.add_exception(player_character.character)
	laser_gun.laser.raycast.add_exception(shield.area)

func get_cursor_detect_area() -> CursorDetectArea:
	return player_character.cursor_detect_area

func can_place_items() -> bool:
	return not player_character.is_airborne()

func setup_sectors() -> void:
	level_map_state.setup_map()
	warp_state.setup_map()
	#power_pole_selection_state.setup_map()

func drop_item(item: ItemData):
	player_character.drop_item(item)

func handle_drop_item(grid_item: ItemGridItem):
	if grid_item.item_data is PlaceableItemData:
		inventory_state.on_placeable_item_dropped(grid_item)
	else:
		player_character.drop_item(grid_item)

func _input(event):
	if event.is_action_pressed("player_interact") and not movement_disabled:
		player_character.emit_just_interacted()
	if event.is_action_pressed("player_climb") and not movement_disabled:
		player_character.emit_just_climbed()
	if event.is_action_pressed("toggle_inventory"):
		shelter_state.on_shelter_closed()
	if event.is_action_pressed("place_object"):
		place_placeable_pressed.emit()
	if event.is_action_pressed("cancel_placing_object"):
		cancel_placing_placeable_pressed.emit()

func _process(_delta):
	camera.position = player_character.character.position

func on_shelter_closed():
	shelter_state.on_shelter_closed()

func _on_shelter_day_ended():
	day_ended.emit()

func _on_day_night_cycle_day_started(_day):
	shelter_inventory.food.subtract_value(Utils.AMOUNT_OF_FOOD_TO_CONSUME)
	player_character.stop_gassing()

func _on_day_night_cycle_day_ended():
	player_character.start_gassing()

func _on_shelter_transport_bucket_arrived(transport_bucket: TransportBucket):
	var inventory_addition: InventoryAddition = transport_bucket.get_inventory().to_inventory_addition()
	inventory_addition.add_item(transport_bucket_item)
	shelter_inventory.add_addition(inventory_addition)
	if inventory_addition.is_empty():
		transport_bucket.kill()
		return
	inventory_addition.remove_item(transport_bucket_item)
	var new_transport_bucket_inventory: Inventory = inventory_addition.to_inventory(transport_bucket.get_inventory().item_grid.size)
	transport_bucket.set_inventory(new_transport_bucket_inventory)

func _on_player_place_object_handler_cancelled_placing():
	placing_object_state.placing_complete()

func _on_player_place_object_handler_placeable_placed(placeable):
	placing_object_state.placeable_placed(placeable)
