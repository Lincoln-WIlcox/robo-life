extends Node

@export var trigger: Trigger

func _ready():
	trigger.activated.connect(on_trigger_activated)

func on_trigger_activated() -> void:
	print("activated!")
