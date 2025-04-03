class_name Trigger
extends Node

##Triggers are created in the world then dependency injected into nodes. 
##Nodes can activate and deactivate the trigger or do something upon a trigger's activation or deactivation.

var _currently_activated: bool = false

signal activated
signal deactivated

func activate() -> void:
	_currently_activated = true
	activated.emit()

func deactivate() -> void:
	_currently_activated = false
	deactivated.emit()

func is_activated() -> bool:
	return _currently_activated
