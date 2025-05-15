class_name Teleportable
extends Node

@export var interactor: Node

signal teleported(new_position: Vector2)

func _ready():
	InteractionServices.get_teleportation_service().register_teleportable(interactor, on_teleported)

func on_teleported(new_position: Vector2) -> void:
	teleported.emit(new_position)
