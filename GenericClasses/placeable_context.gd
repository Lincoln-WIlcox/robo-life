class_name PlaceableContext
extends RefCounted

var world: World
var environment_query_system: EnvironmentQuerySystem
var show_ui: Callable
var hide_ui: Callable
var get_revealed_sectors: Callable
var sector_revealed_signal: Signal

#_show_ui, _hide_ui, and _get_revealed_scetors should be Callables, and _sector_revealed_signal should be a Signal. They have to be variants so they can be null.
func _init(_world: World = null, _environment_query_system: EnvironmentQuerySystem = null, _show_ui: Variant = null, _hide_ui: Variant = null, _get_revealed_sectors: Variant = null, _sector_revealed_signal: Variant = null):
	world = _world
	environment_query_system = _environment_query_system
	if _show_ui is Callable:
		show_ui = _show_ui
	if _hide_ui is Callable:
		hide_ui = _hide_ui
	if _get_revealed_sectors is Callable:
		get_revealed_sectors = _get_revealed_sectors
	if _sector_revealed_signal is Signal:
		sector_revealed_signal = _sector_revealed_signal
