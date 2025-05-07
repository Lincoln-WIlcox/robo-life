class_name PlayerPlaceObjectHandler
extends Node2D

var cursor_detect_area: CursorDetectArea
@export var world: World
@export var environment_query_system: EnvironmentQuerySystem
@export var player: PlayerCharacterController
var can_place_items: Callable
var remove_from_player_inventory: Callable
var show_ui: Callable
var hide_ui: Callable
var get_revealed_sectors: Callable
var sector_revealed_signal: Signal
var _placing_placeable: Placeable
#the item to remove when placeable is placed

var _placeable_context: PlaceableContext

signal placeable_placed(placeable: Placeable)
signal placing_placeable(placeable: Placeable)
signal cancelled_placing

func setup_context() -> void:
	_placeable_context = PlaceableContext.new(world, environment_query_system, show_ui, hide_ui, get_revealed_sectors, sector_revealed_signal)

func _physics_process(delta):
	if _placing_placeable:
		update_placing()

func start_placing_placeable(placeable: Placeable) -> void:
	placeable.initialize(_placeable_context)
	_placing_placeable = placeable
	world.add_child(_placing_placeable)
	placing_placeable.emit(_placing_placeable)

func _stop_placing() -> void:
	_placing_placeable = null

func cancel_placing() -> void:
	_placing_placeable.queue_free()
	_stop_placing()

func update_placing() -> void:
	_placing_placeable.global_position = get_global_mouse_position()
	_placing_placeable.in_range = cursor_detect_area.mouse_over
	_placing_placeable.can_be_placed = can_place_items.call()

func attempt_place_object() -> bool:
	if _placing_placeable.placement_valid and cursor_detect_area.mouse_over and can_place_items.call():
		_placing_placeable.place()
		placeable_placed.emit(_placing_placeable)
		_stop_placing()
		return true
	return false

#if place_object.call() and place_object_handler.attempt_place_object():
		#inventory.remove_grid_item(placeable_item)
		#none_state.just_placed_object = true
		#state_ended.emit(none_state)
	#if cancel_placing_object.call():
		#place_object_handler.cancel_placing()
		#state_ended.emit(none_state)

func _on_player_character_controller_place_placeable_pressed():
	if _placing_placeable:
		attempt_place_object()

func _on_player_character_controller_cancel_placing_placeable_pressed():
	if _placing_placeable:
		cancel_placing()
