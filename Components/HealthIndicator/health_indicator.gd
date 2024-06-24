extends Label

const LABEL = " hp"

@export var health_component: HealthComponent

func _ready():
	text = str(health_component.health) + LABEL
	health_component.health_changed.connect(on_health_changed)

func on_health_changed(health: int):
	text = str(health) + LABEL
