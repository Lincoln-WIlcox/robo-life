class_name TeleportationService
extends Node

var teleportables: Dictionary[Node, Callable] = {}

func register_teleportable(interactor: Node, callback: Callable) -> void:
	teleportables[interactor] = callback

func teleport(interactor: Node, position: Vector2) -> void:
	var callback: Callable = teleportables[interactor]
	
	if callback:
		callback.call(position)
