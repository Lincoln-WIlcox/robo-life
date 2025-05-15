class_name Teleporter
extends Node2D

@export var teleport_destination: Node2D

signal interacted_with

func use_destination(destination: Node2D) -> void:
	teleport_destination = destination

func _on_interaction_area_interacted_with(interactor: Node):
	InteractionServices.get_teleportation_service().teleport(interactor, teleport_destination.global_position)
