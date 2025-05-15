extends Node

@onready var teleportation_service: TeleportationService = $TeleportationService

func get_teleportation_service() -> TeleportationService:
	return teleportation_service
