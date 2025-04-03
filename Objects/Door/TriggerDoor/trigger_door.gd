class_name TriggerDoor
extends Door

@export var trigger: Trigger

func _ready():
	trigger.activated.connect(open)
	trigger.deactivated.connect(close)
