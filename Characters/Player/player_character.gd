class_name PlayerCharacter
extends Node2D

@onready var movement_states: StateMachine = $MovementStates
@onready var standing_state: State = $MovementStates/Standing
@onready var jumping_state: State = $MovementStates/Jumping
@onready var falling_state: State = $MovementStates/Falling
@onready var pushing_state: State = $MovementStates/Pushing
@onready var climbing_state = $MovementStates/Climbing
@onready var ledge_grabbing_state: State = $MovementStates/LedgeGrabbing
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var horizontal_movement_component: HorizontalMovementComponent = $HorizontalMovementComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var ledge_grab_detector: PlayerLedgeGrabDetector = $PlayerLedgeGrabDetector
@onready var animation_handler: Node = $AnimationHandler
@onready var walk_over_item_pickup_collector: Node = $WalkOverItemPickupCollector
@onready var interaction_handler: Node = $InteractionHandler
@onready var interact_indicator_animation: AnimationPlayer = $PlayerCharacterBody/InteractionIndicator/FlashAnimation
@onready var character: CharacterBody2D = $PlayerCharacterBody
@onready var climbing_rope_detector = $ClimbingRopeDetector
@onready var drop_item_left: Marker2D = $PlayerCharacterBody/DropItemLeft
@onready var drop_item_right: Marker2D = $PlayerCharacterBody/DropItemRight
@onready var animated_sprite: AnimatedSprite2D = $PlayerCharacterBody/AnimatedSprite2D
@onready var inventory_interaction_handler = $InventoryInteractionHandler
@onready var drop_item_handler = $DropItemHandler
@onready var cursor_detect_area = $PlayerCharacterBody/CursorDetectArea
@onready var interaction_area = $PlayerCharacterBody/InteractArea
@onready var shield_progress_bar = $PlayerCharacterBody/ShieldProgressBar
@onready var gas_handler = $GasHandler

@export var inventory: Inventory:
	set(new_value):
		inventory = new_value
		if is_inside_tree():
			inventory_interaction_handler.inventory = inventory

var facing_left:
	get:
		return animated_sprite.flip_h

var is_jumping := func(): return false:
	set(new_value):
		is_jumping = new_value
		_update_children()
var just_jumped := func(): return false:
	set(new_value):
		just_jumped = new_value
		_update_children()
var just_climbed_callable := func(): return false:
	set(new_value):
		just_climbed_callable = new_value
		_update_children()
var is_moving_left := func(): return false:
	set(new_value):
		is_moving_left = new_value
		_update_children()
var is_moving_right := func(): return false:
	set(new_value):
		is_moving_right = new_value
		_update_children()
var is_moving_down := func(): return false:
	set(new_value):
		is_moving_down = new_value
		_update_children()
var is_moving_up := func(): return false:
	set(new_value):
		is_moving_up = new_value
		_update_children()
var is_climbing := func(): return false:
	set(new_value):
		is_climbing = new_value
		_update_children()

signal just_interacted
signal just_climbed
signal item_dropped(drop: Object)
signal died
signal shelter_interacted_with(shelter_area: ShelterInteractionArea)

func _ready():
	_update_children()
	interact_indicator_animation.play("flash")
	health_component.health_reached_zero.connect(func(): died.emit())
	inventory_interaction_handler.inventory = inventory

func _update_children():
	pushing_state.is_moving_left = is_moving_left
	pushing_state.is_moving_right = is_moving_right
	pushing_state.just_jumped = just_jumped
	climbing_rope_detector.is_climbing = is_climbing
	climbing_rope_detector.is_moving_down = is_moving_down
	climbing_state.is_climbing = is_climbing
	climbing_state.is_moving_up = is_moving_up
	climbing_state.is_moving_down = is_moving_down
	climbing_state.just_jumped = just_jumped
	standing_state.just_jumped = just_jumped
	standing_state.is_jumping = is_jumping
	standing_state.is_moving_down = is_moving_down
	standing_state.is_moving_left = is_moving_left
	standing_state.is_moving_right = is_moving_right
	standing_state.just_climbed = just_climbed_callable
	jumping_state.is_jumping = is_jumping
	falling_state.is_jumping = is_jumping
	falling_state.is_moving_down = is_moving_down
	falling_state.just_jumped = just_jumped
	ledge_grabbing_state.just_jumped = just_jumped
	ledge_grabbing_state.is_moving_left = is_moving_left
	ledge_grabbing_state.is_moving_right = is_moving_right
	ledge_grabbing_state.is_moving_down = is_moving_down
	horizontal_movement_component.is_moving_left = is_moving_left
	horizontal_movement_component.is_moving_right = is_moving_right
	animation_handler.is_moving_left = is_moving_left
	animation_handler.is_moving_right = is_moving_right

func drop_item(grid_item: ItemGridItem) -> void:
	inventory.remove_grid_item(grid_item)
	drop_item_handler.drop_item(grid_item.item_data)

func start_gassing() -> void:
	gas_handler.start_gassing()

func stop_gassing() -> void:
	gas_handler.stop_gassing()

func emit_just_interacted() -> void:
	just_interacted.emit()

func emit_just_climbed() -> void:
	just_climbed.emit()

func is_airborne() -> bool:
	return falling_state.is_current_state.call() or jumping_state.is_current_state.call()

func _on_drop_item_handler_drop_created(drop):
	item_dropped.emit(drop)

func _on_walk_over_item_pickup_collector_walk_over_item_collected(inventory_addition: InventoryAddition):
	inventory.add_addition(inventory_addition)

func _on_shelter_interaction_area_interaction_handler_shelter_interacted_with(shelter_area: ShelterInteractionArea):
	shelter_interacted_with.emit(shelter_area)
